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
        styles+= <"border-collapse", "separate">;
        if (f.width>=0) styles+= <"width", "<f.width>px">; 
        if (f.height>=0) styles+= <"height", "<f.height>px">;
        r+=salix::HTML::style(styles);
        return r;    
   }
   
list[value] fromTdModelToProperties(Figure f, Figure g) {
    list[tuple[str, str]] styles = [<"padding", 
    "<round(g.padding[1])>px <round(g.padding[2])>px <round(g.padding[3])>px <round(g.padding[0])>px">];
    if (f.borderWidth>=0) styles += <"border-width", "<f.borderWidth>px">;
    if (!isEmpty(f.borderColor)) styles+= <"border-color", "<f.borderColor>">;
    if (!isEmpty(f.borderStyle)) styles+= <"border-style", "<f.borderStyle>">;
    list[value] r =[salix::HTML::style(styles)];
    value q = hAlign(g.cellAlign);
    if (str _:=q) r += hAlign(f.align); else r+=q;
    q = vAlign(g.cellAlign);
    if (str _:=q) r += vAlign(f.align); else r+=q;
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
       list[value] tdArgs = fromTdModelToProperties(outer, inner);
       list[value] tableArgs = foreignObjectArgs; 
       //if (grid():=inner)
       //foreignObject(foreignObjectArgs+[(){table(tableArgs+[(){tr((){td(tdArgs+[(){eval(inner);}]);});}]);}]);
      // else
       foreignObject(foreignObjectArgs+[(){table(tableArgs+[(){tr((){td(tdArgs+[(){svg(svgArgs+[(){eval(inner);}]);}]);});}]);}]);
       };
    } 
     
void() tableCells(Figure f, list[Figure] g) {
    // list[value] foreignObjectArgs = [style(<"line-height", "0">)];
    list[void()] r =[];
    for (Figure h<-g) {
       list[value] svgArgs = [];
       int width = round(h.width); int height = round(h.height);
       int lw = round(h.lineWidth);
       if (width>=0) svgArgs+= salix::SVG::width("<width+lw>px");
       if (height>=0) svgArgs+= salix::SVG::height("<height+lw>px");
       list[value] tdArgs = fromTdModelToProperties(f, h);
       r+= [() {
           salix::HTML::td(tdArgs+[(){svg(svgArgs+[(){eval(h);}]);}]);
        }];
       }
    return () {for  (void() z<-r) z();};
    }
    
void() tableRows(Figure f) {
    list[void()] r =[];
    for (list[Figure] g<-f.figArray) {
     r+= [() {
        salix::HTML::tr(tableCells(f, g));  
        }];
       }
    return () {for (void() z<-r) z();};
    }
   
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
         int width = 0;int height = 0;
         int lw = round(f.borderWidth);
         if (lw<0) lw = 0;
         int nc  = 0;
         for (list[Figure] g<- f.figArray) {
            list[Figure] r = [];
            int w1 = 0; int h1 = 0;   
            for (Figure h<-g)  {
                  int lwi = round(h.lineWidth);
                  if (lwi<0) lwi = 0;
                  Figure v = pullDim(h);
                  if (w1>=0) if (v.width>=0) w1+=v.width+lwi+h.padding[0]+h.padding[2]; else w1= -1;
                  if (h1>=0) if (v.height>=0) h1 = max(h1, v.height+lwi+h.padding[1]+h.padding[3]);
                  r += [v];      
                  }
            nc = max(nc, size(g));
            if (width>=0) if (w1>=0) width = max(width, w1); else width = -1;
            if (height>=0) if (h1>=0) height+=h1; else height = -1;     
            z+=[r];
            }   
          f.figArray= z;
          f.width = width+nc*(f.hgap+2*lw)+2*lw+f.hgap; f.height = height+size(z)*(f.vgap+2*lw)+2*lw+f.vgap;
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
     Figure root = root(width = round(width), height = round(height));
     root.fig = f;
     root = solveDim(root);
     eval(root);
     }
     
void eval(emptyFigure()) {;}

void eval(Figure f:root()) {svg(fromSvgModelToProperties(f)+[() {eval(f.fig);}]);}

void eval(Figure f:box()) {\rect(fromSvgModelToProperties(f));if (emptyFigure()!:=f.fig) innerFig(f, f.fig)();}

void eval(Figure f:grid()) {
                   list[value] foreignObjectArgs = [style(<"line-height", "0">)];
                   foreignObject(foreignObjectArgs+[(){salix::HTML::table(fromTableModelToProperties(f)+[tableRows(f)]);}]);
                   }
     