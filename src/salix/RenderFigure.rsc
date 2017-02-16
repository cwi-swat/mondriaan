module salix::RenderFigure
import util::Math;
import salix::SVG;
import salix::HTML;
import salix::App;
import salix::Core;
import shapes::Figure;
import Prelude;

data Msg = 
  msg(str)
  |noMsg()
  ; 

data Event = onclick(Msg m);

data Figure = root(Figure fig= emptyFigure());

data Figure (void() before = (){}, void() after = (){});

alias Model = map[Figure
   ,tuple[tuple[bool width, bool height] isAssigned
   ,num x, num y, num width, num height, num grow, num shrink
   ,str fill, num strokeWidth, str stroke, str visibility, Alignment align, Msg onclick
   ,tuple[num hgap, num vgap, num width, str color, str style] border
   ,tuple[num left, num top, num right, num bottom] padding]
   ];
   
Model createStartModel(list[Figure] fs) {
     Model r = (f:<<f.width>=0, f.height>=0>, f.at[0], f.at[1], f.width, f.height, f.grow, f.shrink, f.fillColor, f.lineWidth, f.lineColor, f.visibility,
     f.align, noMsg()
     ,<f.hgap, f.vgap, f.borderWidth,f.borderColor,f.borderStyle>
     ,f.padding>|f<-fs); 
     for (f<-r) {
        if (onclick(Msg msg):=f.event) r[f].onclick = msg;
        }
     return r;
     }
  
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
       
list[value] fromSvgModelToProperties(Figure f, Model m) {
   list[value] r =[];
   int lwo = round(m[f].strokeWidth); 
   if (lwo<0) lwo = 0;
   if (m[f].width>=0) r+= salix::SVG::width("<m[f].width>px"); 
   if (m[f].height>=0) r+= salix::SVG::height("<m[f].height>px");
   r+= salix::SVG::x("<m[f].x+lwo/2>px"); r+= salix::SVG::y("<m[f].y+lwo/2>px");
   if (!isEmpty(m[f].fill)) r+= salix::SVG::fill(m[f].fill);
   if (!isEmpty(m[f].stroke)) r+= salix::SVG::stroke(m[f].stroke);
   if (m[f].strokeWidth>=0) r+= salix::SVG::strokeWidth("<m[f].strokeWidth>px");
   if (!isEmpty(m[f].visibility)) r+= salix::SVG::visibility(m[f].visibility);
   if (Msg q:msg(_):= m[f].onclick)  r+=salix::SVG::onClick(q);
   return r;
   }
   
list[value] fromTableModelToProperties(Figure f, Model m) {
    list[value] r =[];
    list[tuple[str, str]] styles=[];
        if (m[f].border.width>=0) styles += <"border-width", "<m[f].border.width>px">;
        styles += <"border-spacing", "<m[f].border.hgap>px <m[f].border.vgap>px">;
        if (!isEmpty(m[f].border.color)) styles+= <"border-color", "<m[f].border.color>">;
        if (!isEmpty(m[f].border.style)) styles+= <"border-style", "<m[f].border.style>">;
        if (m[f].width>=0) styles+= <"width", "<m[f].width>px">; 
        if (m[f].height>=0) styles+= <"height", "<m[f].height>px">;
        r+=salix::HTML::style(styles);
        return r;    
   }
   
list[value] fromTdModelToProperties(Figure f, Model m) {
    list[tuple[str, str]] styles = [<"padding", 
    "<round(m[f].padding.top)>px <round(m[f].padding.right)>px <round(m[f].padding.bottom)>px <round(m[f].padding.left)>px">];
    list[value] r =[salix::HTML::style(styles)];
    r += hAlign(m[f].align); r += vAlign(m[f].align);
    return r;
    }
   
void() innerFig(Model m, Figure outer, Figure inner) {
    return (){
       int lwo = round(m[outer].strokeWidth); int lwi = round(m[inner].strokeWidth);
       if (lwo<0) lwo = 0; if (lwi<0) lwi = 0;
       int widtho = round(m[outer].width); int heighto = round(m[outer].height);
       int widthi = round(m[inner].width); int heighti = round(m[inner].height);    
       list[value] svgArgs = [];
       if (widthi>=0) svgArgs+= salix::SVG::width("<widthi+lwi>px");
       if (heighti>=0) svgArgs+= salix::SVG::height("<heighti+lwi>px");
       list[value] foreignObjectArgs = [style(<"line-height", "0">)];
       if (widtho>=0) foreignObjectArgs+= salix::SVG::width("<widtho-lwo>px");
       if (heighto>=0) foreignObjectArgs+= salix::SVG::height("<heighto-lwo>px");
       foreignObjectArgs+= salix::SVG::x("<lwo>px"); foreignObjectArgs+= salix::SVG::y("<lwo>px");
       list[value] tdArgs = fromTdModelToProperties(outer, m);
       list[value] tableArgs = foreignObjectArgs; 
       if (grid():=inner)
       foreignObject(foreignObjectArgs+[(){table(tableArgs+[(){tr((){td(tdArgs+[(){eval(inner, m);}]);});}]);}]);
       else
       foreignObject(foreignObjectArgs+[(){table(tableArgs+[(){tr((){td(tdArgs+[(){svg(svgArgs+[(){eval(inner, m);}]);}]);});}]);}]);
       };
    } 
     
list[void()] tableCells(Figure f, list[Figure] g, Model m) {
    list[value] tdArgs = fromTdModelToProperties(f, m);
    list[void()] r =[];
    for (Figure h<-g) {
       list[value] svgArgs = [];
       int width = round(m[h].width); int height = round(m[h].height);
       int lw = round(m[h].strokeWidth);
       if (width>=0) svgArgs+= salix::SVG::width("<width+lw>px");
       if (height>=0) svgArgs+= salix::SVG::height("<height+lw>px");
       r+= [() {
           salix::HTML::td(tdArgs+[(){svg(svgArgs+[(){eval(h, m);}]);}]);
        }];
       }
    return r;
    }
    
list[void()] tableRows(Figure f, Model m) {
    list[void()] r =[];
    for (list[Figure] g<-f.figArray) {
     r+= [() {
        salix::HTML::tr(tableCells(f, g, m));  
        }];
       }
    return r;
    }
  
void eval(Figure f, Model m) {
    switch(f) {
        case emptyFigure():;
        case root(): svg(fromSvgModelToProperties(f, m)+[() {eval(f.fig, m);}]);
        case box(): {
         \rect(fromSvgModelToProperties(f, m)
         );
         if (emptyFigure()!:=f.fig) innerFig(m, f, f.fig)();
         }
        case grid(): {
            foreignObject([(){salix::HTML::table(fromTableModelToProperties(f, m)+tableRows(f, m));}]);
            }
        }
    }
       
 public Figure getRoot(Model m) {
     for (f<-m) {
        if (root():=f) return f;
        }
     return emptyFigure();
     }
     
 list[Figure] getFigures(list[Figure] fs, Figure f) {
     if (f==emptyFigure()) return fs;
     if (root():=f || box():=f) fs = getFigures(fs, f.fig);
     if (grid():=f) fs = [*[*getFigures(fs, h)|h<-g]|g<-f.figArray];
     return fs+f;
     }
     
 
 Model pullDim(Figure f, Model m) {
     if ((root():=f || box():=f) && emptyFigure()!:=f.fig) {
        Figure g = f.fig;
        m = pullDim(g, m);
        int lwo = round(m[f].strokeWidth); int lwi = round(m[g].strokeWidth);
        if (lwo<0) lwo = 0; if (lwi<0) lwi = 0;
        if (!m[f].isAssigned.width && m[g].width>=0) m[f].width = m[f].grow*m[g].width + lwi+round(m[g].x)+lwo;
        if (!m[f].isAssigned.height && m[g].height>=0) m[f].height = m[f].grow*m[g].height + lwi+round(m[g].y)+lwo;
        }
     if (grid():=f) 
         for (list[Figure] g<- f.figArray) for (Figure h<-g) m = pullDim(h, m);
     return m;
     }
     
 Model pushDim(Figure f, Model m) {
     if ((root():=f || box():=f) && emptyFigure()!:=f.fig) {
           Figure g = f.fig;  
           if ((root():=g || box():=g) && emptyFigure()!:=f) {
           int lwo = round(m[f].strokeWidth); int lwi = round(m[g].strokeWidth);
           if (lwo<0) lwo = 0; if (lwi<0) lwi = 0;
           if (!m[g].isAssigned.width && m[f].width>=0) m[g].width = m[f].shrink*m[f].width - lwi -round(m[g].x) - lwo;
           if (!m[g].isAssigned.height && m[f].height>=0) m[g].height = m[f].shrink*m[f].height -lwi - round(m[g].y)-lwo;
           m = pushDim(g, m);
        }
     }
     if (grid():=f) 
         for (list[Figure] g<- f.figArray) for (Figure h<-g) m = pushDim(h, m);
     return m;
     }
     
 Model solveStepDim(Figure f, Model m) {
     Model t = pushDim(f, m);
     return pullDim(f, t);
     }
     
 Model solveDim(Figure f, Model old, Model m) {
     for (Figure f<-m) {
          if (m[f].width != old[f].width) m[f].isAssigned.width = true;
          if (m[f].height != old[f].height) m[f].isAssigned.height = true;
          }
     return solve(m) solveStepDim(f, m);
     }
  
 
 App[Model] figApp(Figure f, Model(Msg, Model) update, int width = -1, int height = -1, int fillColor="") {
     Figure root = root(width = width, height = height, fillColor= fillColor);
     root.fig = f;
     Model startModel = createStartModel(getFigures([], root));
     Model init() {Model r = startModel; return solveDim(root, r, r);} 
     Model extendUpdate(Msg msg, Model m) {
           Model r = update(msg, m); 
           r=solveDim(root, m, r); return r;
           }  
     void(Model) view(Figure f) {return void(Model m) {
       body([/*style(<"line-height", "0">)*/]+[() {div(() {
          f.before();
          eval(root, m);
          f.after();
          });
        }]);
       };
      };
  
  return app(init, view(f), extendUpdate, 
    |http://localhost:9103|, |project://salix/src|);
   }
       

      
