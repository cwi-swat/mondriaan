module salix::LayoutFigure
import util::Math;
import salix::SVG;
import salix::HTML;
import salix::App;
import salix::Core;
import shapes::Figure;
import Prelude;

data Figure = root(Figure fig= emptyFigure());
data Event = onclick(Msg m);

value vAlign(Alignment align) {
       if (align == bottomLeft || align == bottomMid || align == bottomRight) return salix::HTML::valign("bottom");
       if (align == centerLeft || align ==centerMid || align ==centerRight)  return salix::HTML::valign("middle");
       if (align == topLeft || align == topMid || align == topRight) return salix::HTML::valign("top");
       return "";
       }
       
value hAlign(Alignment align) {
       if (align == bottomLeft || align == centerLeft || align == topLeft) return salix::HTML::align("left");
       if (align == bottomMid || align == centerMid || align == topMid) return salix::HTML::align("center");
       if (align == bottomRight || align == centerRight || align == topRight) return salix::HTML::align("right");
       return "";   
       }
       
list[value] fromSvgModelToProperties(Figure f) {
   list[value] r =[];
   int lwo = round(f.lineWidth); 
   if (lwo<0) lwo = 0;
   if (f.width>=0) r+= salix::SVG::width("<f.width>px"); 
   if (f.height>=0) r+= salix::SVG::height("<f.height>px");
   r+= salix::SVG::x("<f.at[0]+lwo/2>px"); r+= salix::SVG::y("<f.at[1]+lwo/2>px");
   if (!isEmpty(f.fillColor)) r+= salix::SVG::fill(f.fillColor);
   if (!isEmpty(f.lineColor)) r+= salix::SVG::stroke(f.lineColor);
   if (f.lineWidth>=0) r+= salix::SVG::strokeWidth("<f.lineWidth>px");
   if (!isEmpty(f.visibility)) r+= salix::SVG::visibility(f.visibility);
   if (Event q:= f.event)  if (onclick(Msg msg):=q) r+=salix::SVG::onClick(msg);
   return r;
   }
   
list[value] fromTableModelToProperties(Figure f) {
    list[value] r =[];
    list[tuple[str, str]] styles=[];
        if (f.borderWidth>=0) styles += <"border-width", "<f.borderWidth>px">;
        styles += <"border-spacing", "<f.hgap>px <f.vgap>px">;
        if (!isEmpty(f.borderColor)) styles+= <"border-color", "<f.borderColor>">;
        if (!isEmpty(f.borderStyle)) styles+= <"border-style", "<f.borderStyle>">;
        if (f.width>=0) styles+= <"width", "<f.width>px">; 
        if (f.height>=0) styles+= <"height", "<f.height>px">;
        r+=salix::HTML::style(styles);
        return r;    
   }
   
list[value] fromTdModelToProperties(Figure f) {
    list[tuple[str, str]] styles = [<"padding", 
    "<round(f.padding[1])>px <round(f.padding[2])>px <round(f.padding[3])>px <round(f.padding[0])>px">];
    list[value] r =[salix::HTML::style(styles)];
    r += hAlign(f.align); r += vAlign(f.align);
    return r;
    }
   
void() innerFig(Figure outer, Figure inner) {
    return (){
       int lwo = round(outer.lineWidth); int lwi = round(inner.lineWidth);
       if (lwo<0) lwo = 0; if (lwi<0) lwi = 0;
       int widtho = round(outer.width); int heighto = round(outer.height);
       int widthi = round(inner.width); int heighti = round(inner.height);    
       list[value] svgArgs = [];
       if (widthi>=0) svgArgs+= salix::SVG::width("<widthi+lwi>px");
       if (heighti>=0) svgArgs+= salix::SVG::height("<heighti+lwi>px");
       list[value] foreignObjectArgs = [style(<"line-height", "0">)];
       if (widtho>=0) foreignObjectArgs+= salix::SVG::width("<widtho-lwo>px");
       if (heighto>=0) foreignObjectArgs+= salix::SVG::height("<heighto-lwo>px");
       foreignObjectArgs+= salix::SVG::x("<lwo>px"); foreignObjectArgs+= salix::SVG::y("<lwo>px");
       list[value] tdArgs = fromTdModelToProperties(outer);
       list[value] tableArgs = foreignObjectArgs; 
       if (grid():=inner)
       foreignObject(foreignObjectArgs+[(){table(tableArgs+[(){tr((){td(tdArgs+[(){eval(inner);}]);});}]);}]);
       else
       foreignObject(foreignObjectArgs+[(){table(tableArgs+[(){tr((){td(tdArgs+[(){svg(svgArgs+[(){eval(inner);}]);}]);});}]);}]);
       };
    } 
     
list[void()] tableCells(Figure f, list[Figure] g) {
    list[value] tdArgs = fromTdModelToProperties(f);
    list[void()] r =[];
    for (Figure h<-g) {
       list[value] svgArgs = [];
       int width = round(h.width); int height = round(h.height);
       int lw = round(h.lineWidth);
       if (width>=0) svgArgs+= salix::SVG::width("<width+lw>px");
       if (height>=0) svgArgs+= salix::SVG::height("<height+lw>px");
       r+= [() {
           salix::HTML::td(tdArgs+[(){svg(svgArgs+[(){eval(h);}]);}]);
        }];
       }
    return r;
    }
    
list[void()] tableRows(Figure f) {
    list[void()] r =[];
    for (list[Figure] g<-f.figArray) {
     r+= [() {
        salix::HTML::tr(tableCells(f, g));  
        }];
       }
    return r;
    }
  
void eval(Figure f) {
    switch(f) {
        case emptyFigure():;
        case root(): svg(fromSvgModelToProperties(f)+[() {eval(f.fig);}]);
        case box(): {
         \rect(fromSvgModelToProperties(f)
         );
         if (emptyFigure()!:=f.fig) innerFig(f, f.fig)();
         }
        case grid(): {
            foreignObject([(){salix::HTML::table(fromTableModelToProperties(f)+tableRows(f));}]);
            }
        }
    }
 
 /*      
 public Figure getRoot(Model m) {
     for (f<-m) {
        if (root():=f) return f;
        }
     return emptyFigure();
     }
 */
 Figure pullDim(Figure f) {
     if ((root():=f || box():=f) && emptyFigure()!:=f.fig) {
        f.fig = pullDim(f.fig);
        Figure g = f.fig;
        int lwo = round(f.lineWidth); int lwi = round(g.lineWidth);
        if (lwo<0) lwo = 0; if (lwi<0) lwi = 0;
        if (f.width<0 && g.width>=0) f.width = round(f.grow*g.width) + lwi+round(g.at[0])+lwo;
        if (f.height<0 && g.height>=0) f.height = round(f.grow*g.height) + lwi+round(g.at[1])+lwo;
        }
     if (grid():=f) {
         list[list[Figure]] z =[];
         for (list[Figure] g<- f.figArray) {
            list[Figure] r = [];
            for (Figure h<-g)  r += pullDim(h);
            z+=r;
            }
          f.figArray= z;
          }
     return f;
     }
     
 Figure pushDim(Figure f) {
     if ((root():=f || box():=f) && emptyFigure()!:=f.fig) {
           Figure g = f.fig;  
           if ((root():=g || box():=g) && emptyFigure()!:=f) {
           int lwo = round(f.lineWidth); int lwi = round(g.lineWidth);
           if (lwo<0) lwo = 0; if (lwi<0) lwi = 0;
           if (g.width<0 && f.width>=0) g.width = round(f.shrink*f.width) - lwi -round(g.at[0]) - lwo;
           if (g.height<0 && f.height>=0) g.height = round(f.shrink*f.height) -lwi - round(g.at[1])-lwo;
           f.fig = pushDim(g);
        }
     }
     if (grid():=f) {
         list[list[Figure]] z =[];
         for (list[Figure] g<- f.figArray) {
            list[Figure] r = [];
            for (Figure h<-g)  r += pushDim(h);
            z+=r;
            }
          f.figArray= z;
          }
     return f;
     }
     
 Figure solveStepDim(Figure f) {
     f = pullDim(f);
     return pushDim(f);
     }
     
 Figure solveDim(Figure f) {
     return solve(f) solveStepDim(f);
     }
     
 public void fig(Figure f, num width = -1, num height = -1) {
     Figure root = root(width = width, height = height);
     root.fig = f;
     root = solveDim(root);
     eval(root);
     }
     
  
     
 
     