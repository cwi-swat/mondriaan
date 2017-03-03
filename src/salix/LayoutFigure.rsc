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
   if (shapes::Figure::circle()!:=f && shapes::Figure::ellipse()!=f) {
      if (f.width>=0) r+= salix::SVG::width("<f.width>px"); 
      if (f.height>=0) r+= salix::SVG::height("<f.height>px");
      r+= salix::SVG::x("<f.at[0]+lwo/2>px"); r+= salix::SVG::y("<f.at[1]+lwo/2>px");
      }
   if (shapes::Figure::circle():=f) {
        if (f.r<0 && f.width>=0 && f.height>=0) f.r = max(f.width, f.height)/2;
        if (f.r>=0) {r+= salix::SVG::r("<f.r>px");
                r+= salix::SVG::cx("<f.at[0]+f.r+lwo/2>px");
                r+= salix::SVG::cy("<f.at[1]+f.r+lwo/2>px");
                }
        }
   if (shapes::Figure::ellipse():=f) {
        if (f.rx<0 && f.width>=0) f.rx = f.width/2;
        if (f.ry<0 && f.height>=0) f.ry = f.height/2;
        if (f.rx>=0) {r+= salix::SVG::rx("<f.rx>px");
                      r+= salix::SVG::cx("<f.at[0]+f.rx+lwo/2>px");
                      }
        if (f.ry>=0) {r+= salix::SVG::ry("<f.ry>px");
                      r+= salix::SVG::cy("<f.at[1]+f.ry+lwo/2>px");
                      }
        }
   if (!isEmpty(f.fillColor)) r+= salix::SVG::fill(f.fillColor);
   if (!isEmpty(f.lineColor)) r+= salix::SVG::stroke(f.lineColor);
   if (f.lineWidth>=0) r+= salix::SVG::strokeWidth("<f.lineWidth>px");
   if (!isEmpty(f.visibility)) r+= salix::SVG::visibility(f.visibility);
   if (Event q:= f.event)  if (onclick(Msg msg):=q) r+=salix::SVG::onClick(msg);
   return r;
   }
   
list[value] svgSize(Figure f) {
   list[value] r =[];
   int lw = round(f.lineWidth); 
   if (lw<0) lw = 0;
   if (f.width>=0) r+= salix::SVG::width("<f.width+f.at[0]+lw>px"); 
   if (f.height>=0) r+= salix::SVG::height("<f.height+f.at[1]+lw>px");
   return r;
   }
   
list[value] TextModelToProperties(Figure f, bool svg) {
    list[tuple[str, str]] styles=[]; 
    if (!svg) styles+= <"overflow", f.overflow>; 
    int fontSize = (f.fontSize>=0)?f.fontSize:12;
    styles+=<"font-size", "<fontSize>px">;
    if (!isEmpty(f.fontStyle)) styles+=<"font-style", f.fontStyle>;
    if (!isEmpty(f.fontFamily)) styles+=<"font-family", f.fontFamily>;
    if (!isEmpty(f.fontWeight)) styles+= <"font-weight", f.fontWeight>;
    if (!isEmpty(f.textDecoration)) styles+=<"text-decoration", f.textDecoration>;
    if (!isEmpty(f.fontColor)) styles+=<(svg?"fill":"color"), f.fontColor>;
    if (svg) {
        if (!isEmpty(f.fontLineColor)) styles+= <"stroke",f.fontLineColor>;
        if (f.fontLineWidth>=0) styles+=<"stroke-width", "<f.fontLineWidth>px">;
        styles+=<"text-anchor", "middle">;
        }
    if (f.width>=0) styles+= <"width", "<f.width>px">; 
    if (f.height>=0) styles+= <"height", "<f.height>px">;
    list[value] r =[salix::HTML::style(styles)];
    if (svg) {
        if (f.width>=0) r+=salix::SVG::x("<f.width/2>px");
        if (f.height>=0) r+=salix::SVG::y("<f.height/2+6>px");
        }
    return r;
   }
   
list[value] fromTableModelToProperties(Figure f) {
    list[value] r =[];
    list[tuple[str, str]] styles=[];     
        styles += <"border-spacing", "<f.hgap>px <f.vgap>px">;
        styles+= <"border-collapse", "separate">;
        //if (f.width>=0) styles+= <"width", "<f.width>px">; 
        // if (f.height>=0) styles+= <"height", "<f.height>px">;
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
       if (widthi>=0) svgArgs+= salix::SVG::width("<widthi+lwi+inner.at[0]>px");
       if (heighti>=0) svgArgs+= salix::SVG::height("<heighti+lwi+inner.at[1]>px");
       list[value] foreignObjectArgs = [style(<"line-height", "0">)];
       if (widtho>=0) foreignObjectArgs+= salix::SVG::width("<widtho-lwo>px");
       if (heighto>=0) foreignObjectArgs+= salix::SVG::height("<heighto-lwo>px");
       foreignObjectArgs+= salix::SVG::x("<lwo>px"); foreignObjectArgs+= salix::SVG::y("<lwo>px");
       list[value] tdArgs = fromTdModelToProperties(outer, inner);
       list[value] tableArgs = foreignObjectArgs; 
       foreignObject(foreignObjectArgs+[(){table(tableArgs+[(){tr((){td(tdArgs+[(){svg(svgArgs+[(){eval(inner);}]);}]);});}]);}]);
       };
    } 
     
void() tableCells(Figure f, list[Figure] g) {
    list[void()] r =[];
    for (Figure h<-g) {
       Figure w= h; // Because of bug in rascal?
       list[value] svgArgs = [];
       int width = round(h.width); int height = round(h.height);
       int lw = round(h.lineWidth);
       if (lw<0) lw = 0;
       if (width>=0) svgArgs+= salix::SVG::width("<width+lw+h.at[0]>px");
       if (height>=0) svgArgs+= salix::SVG::height("<height+lw+h.at[1]>px");
       list[value] tdArgs = fromTdModelToProperties(f, h); 
       r+= [() {
           salix::HTML::td(tdArgs+[(){svg(svgArgs+[(){eval(w);}]);}]);
        }];
       }
    return () {for  (void() z<-r) z();};
    }
    
void() tableRows(Figure f) {
    list[void()] r =[];
    list[list[Figure]] figArray = [];
    if (grid():=f) figArray = f.figArray;
    else if (vcat():=f) figArray  = [[h]|h<-f.figs];    
    else if (hcat():=f) figArray  = [f.figs];
    for (list[Figure] g<-figArray) {
    list[Figure] w  = g;
    r+= [() {
        salix::HTML::tr(tableCells(f, w));  
        }];
       }
    return () {for (void() z<-r) z();};
    }
    
num getGrowFactor(Figure f, Figure g) {
    if ((shapes::Figure::circle():=f||shapes::Figure::ellipse():=f)&&box():=g) return sqrt(2);
    return 1;
    }
    
bool hasFigField(Figure f) = root():=f || box():=f || shapes::Figure::circle():=f || shapes::Figure::ellipse():=f;

Figure pullDim(Figure f:overlay()) {
    if (f.size != <0, 0>) {
       if (f.width<0) f.width = f.size[0];
       if (f.height<0) f.height = f.size[1];
       }  
    if (isEmpty(f.figs)) return f;
    f.figs = [pullDim(h)|Figure h<-f.figs];
    int maxWidth = round(max([h.width+h.at[0]+2*(h.lineWidth<0?0:h.lineWidth)+10|h<-f.figs]));
    int maxHeight = round(max([h.height+h.at[1]+2*(h.lineWidth<0?0:h.lineWidth)+10|h<-f.figs]));
    if (f.width<0) f.width = maxWidth;
    if (f.height<0) f.height = maxHeight;
    return f;
    }
      
Figure pullDim(Figure f) {
     if (f.size != <0, 0>) {
       if (f.width<0) f.width = f.size[0];
       if (f.height<0) f.height = f.size[1];
       }  
     if (shapes::Figure::circle():=f && f.width<0 && f.height<0 && f.r>=0) {
            f.width = 2 * round(f.r); f.height = 2 * round(f.r);
        }
     if (shapes::Figure::ellipse():=f) {
           if (f.width<0 && f.rx>=0) {
              f.width = 2 * round(f.rx); 
              }
           if (f.height<0 && f.ry>=0) {
              f.height = 2 * round(f.ry); 
              }
           }
     if (hasFigField(f) && emptyFigure()!:=f.fig) {    
        f.fig = pullDim(f.fig);
        Figure g = f.fig;
        int lwo = round(f.lineWidth); int lwi = round(g.lineWidth);
        if (lwo<0) lwo = 0; if (lwi<0) lwi = 0;
        if (f.width<0 && g.width>=0) f.width = round(f.grow*getGrowFactor(f, g)*g.width) + lwi+round(g.at[0])+lwo;
        if (f.height<0 && g.height>=0) f.height = round(f.grow*getGrowFactor(f, g)*g.height) + lwi+round(g.at[1])+lwo;
        // To Do the case of a circle
        }
     if (grid():=f || vcat():=f || hcat():=f) {
         list[list[Figure]] z =[];
         int height = 0;
         int lw = round(f.borderWidth);
         if (lw<0) lw = 0;
         int nc  = 0;
         list[list[Figure]] figArray = [];
         if (grid():=f) figArray = f.figArray;
         else if (vcat():=f) figArray= [[h]|h<-f.figs]; 
         else if (hcat():=f) figArray  = [f.figs];
         list[int] maxColWidth = [0|_<-[0..max([size(g)|g<-figArray])]];
         for (list[Figure] g<- figArray) {
            list[Figure] r = [];
            int h1 = 0;
            int i = 0;   
            for (Figure h<-g)  {
                  int lwi = round(h.lineWidth);
                  if (lwi<0) lwi = 0;
                  Figure v = pullDim(h);
                  int colWidth = v.width>=0?(v.width+lwi+h.padding[0]+h.padding[2]+round(h.at[0])):-1;
                  if (maxColWidth[i]<colWidth) maxColWidth[i] = colWidth;
                  if (h1>=0) if (v.height>=0) h1 = max([h1, v.height+lwi+h.padding[1]+h.padding[3]+round(h.at[1])]);else h1=-1;
                  r += [v]; 
                  i += 1;     
                  }
            nc = max(nc, size(g));
            if (height>=0) if (h1>=0) height+=h1; else height = -1;     
            z+=[r];
            } 
          int width = sum(maxColWidth);  
          if (grid():=f) f.figArray= z;
          else
          if (vcat():=f) f.figs = [head(h)|list[Figure] h<-z];
          else
          if (hcat():=f) f.figs = head(z);
          if (f.width<0) f.width = width+nc*(f.hgap+2*lw)+f.hgap; 
          if (f.height<0) f.height = height+size(z)*(f.vgap+2*lw)+f.vgap;
          }
     return f;
     }
     
 list[list[Figure]] transpose(list[list[Figure]] m) {
     list[list[Figure]] r = [[]|_<-[0..max([size(g)|g<-m])]];
     for (int i<-[0..size(m)]) {
          for (int j<-[0..size(m[i])]) {
             r[j]+=m[i];
          }
       }
     return r;    
     }
     
 tuple[num, list[Figure]] getHeightMissingCells(Figure f) {
     if (f.height<0) return <-1, []>;
     int lw = round(f.borderWidth);
     num height = -1;
     if (lw<0) lw = 0;
     list[list[Figure]] figArray = [];
     if (grid():=f) figArray = f.figArray;
         else if (vcat():=f) figArray= [[h]|h<-f.figs]; 
         else if (hcat():=f) figArray  = [f.figs]; 
     list[Figure] result=[];
     int nUndefinedRows = 0;
     int definedHeight = 0;
     for (list[Figure] g<- figArray) {
         bool isDefined = false;
         for (Figure h<-g) {
         if (h.height>=0) {
              isDefined=true;
              definedHeight+=h.height;
              }
         }
         if (!isDefined) {
                 result=concat([result, g]);
                 nUndefinedRows+=1;
                 }
              }
     if (nUndefinedRows>0) height = (f.height-definedHeight-size(figArray)*(f.vgap+2*lw)-f.vgap)/nUndefinedRows;
     //  println("height=<height>");
     return <height, result>;  
     }
     
 tuple[num, list[Figure]] getWidthMissingCells(Figure f) {
     if (f.width<0) return <-1, []>;
     int lw = round(f.borderWidth);
     num width = -1;
     if (lw<0) lw = 0;
     list[list[Figure]] figArray = [];
     if (grid():=f) figArray = f.figArray;
         else if (vcat():=f) figArray= [[h]|h<-f.figs]; 
         else if (hcat():=f) figArray  = [f.figs]; 
     figArray = transpose(figArray);
     // println(figArray);
     list[Figure] result=[];
     int nUndefinedCols = 0;
     int definedWidth = 0;
     for (list[Figure] g<- figArray) {
         bool isDefined = false;
         for (Figure h<-g) {
         if (h.width>0) {
              isDefined=true;
              definedWidth+=h.width;
              }
         }
         if (!isDefined) {
                 result=concat([result, g]);
                 nUndefinedCols+=1;
                 }
              }
     if (nUndefinedCols>0) width = (f.width-definedWidth-size(figArray)*(f.hgap+2*lw)-f.vgap)/nUndefinedCols;
     // println("width=<width>");
     return <width, result>;  
     }
     
 Figure pushDim(Figure f:overlay()) {
    if (isEmpty(f.figs)) return f;
    if (f.width>=0)
    for (Figure h<-f.figs) {
       if (h.width<0) h.width = f.width;
       }
    if (f.height>=0)
    for (Figure h<-f.figs) {
       if (h.height<0) h.width = f.height;
       }
    f.figs = [pushDim(h)|h<-f.figs];
    return f;
    }
     
 Figure pushDim(Figure f) {
     if (f.size != <0, 0>) {
       if (f.width<0) f.width = f.size[0];
       if (f.height<0) f.height = f.size[1];
       }
     if (hasFigField(f) && emptyFigure()!:=f.fig) {
           Figure g = f.fig;  
           int lwo = round(f.lineWidth); int lwi = round(g.lineWidth);
           if (lwo<0) lwo = 0; if (lwi<0) lwi = 0;
           if (g.width<0 && f.width>=0) g.width = round(g.shrink*(f.width-lwo)) - lwi -round(g.at[0]);
           if (g.height<0 && f.height>=0) g.height = round(g.shrink*(f.height-lwo)) -lwi - round(g.at[1]);
           f.fig = pushDim(g);
     }
     if (grid():=f || vcat():=f || hcat():=f) {
         int lw = round(f.borderWidth);
         if (lw<0) lw = 0;
         list[list[Figure]] figArray = [];
         if (grid():=f) figArray = f.figArray;
         else if (vcat():=f) figArray= [[h]|h<-f.figs]; 
         else if (hcat():=f) figArray  = [f.figs];
         tuple[num height, list[Figure] figs] cellsH = getHeightMissingCells(f);
         tuple[num width, list[Figure] figs] cellsW = getWidthMissingCells(f);
          list[list[Figure]] z =[];
          for (list[Figure] g<-figArray) {
              list[Figure] r = [];
              for (Figure h<-g) {  
                  Figure z = h;
                  if (indexOf(cellsW.figs, z)>=0 && cellsW.width>=0) h.width =   round(cellsW.width*h.shrink); 
                  if (indexOf(cellsH.figs, z)>=0 && cellsH.height>=0) h.height =   round(cellsH.height*h.shrink);     
                  r += pushDim(h);  
                  }
              z+=[r];
              }
          if (grid():=f) f.figArray= z;
          else
          if (vcat():=f) f.figs = [head(h)|list[Figure] h<-z];
          else
          if (hcat():=f) f.figs = head(z);
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
     if (root.size != <0, 0>) {
       if (root.width<0) f.width = f.size[0];
       if (root.height<0) f.height = f.size[1];
       }
     root.fig = f;
     root = solveDim(root);
     eval(root);
     }
/*    
 str adjustText(str v, bool html) {
    if (isEmpty(v)) return "";
    s = replaceAll(v,"\\", "\\\\");
    s = replaceAll(s,"\n", "\\\n");
    s = "\"<replaceAll(s,"\"", "\\\"")>\""; 
    return s;
    }
*/
     
void eval(emptyFigure()) {;}

void eval(Figure f:root()) {svg(svgSize(f)+[() {eval(f.fig);}]);}

void eval(Figure f:overlay()) {svg(svgSize(f)+[(){for (g<-f.figs) {svg(svgSize(g)+[() {eval(g);}]);}}]);}

void eval(Figure f:box()) {\rect(fromSvgModelToProperties(f));if (emptyFigure()!:=f.fig) innerFig(f, f.fig)();}

void eval(Figure f:shapes::Figure::circle()) {salix::SVG::circle(fromSvgModelToProperties(f));if (emptyFigure()!:=f.fig) innerFig(f, f.fig)();}

void eval(Figure f:shapes::Figure::ellipse()) {salix::SVG::ellipse(fromSvgModelToProperties(f));if (emptyFigure()!:=f.fig) innerFig(f, f.fig)();}

void eval(Figure f:htmlText(value v)) {
     int lw = round(f.lineWidth); 
     if (lw<0) lw = 0;
     int width = round(f.width); int height = round(f.height); 
     list[value] foreignObjectArgs = [style(<"line-height", "1.5">)];
     if (width>=0) foreignObjectArgs+= salix::SVG::width("<width-lw>px");
     if (height>=0) foreignObjectArgs+= salix::SVG::height("<height-lw>px");
     foreignObjectArgs+= salix::SVG::x("<lw>px"); foreignObjectArgs+= salix::SVG::y("<lw>px");
     list[tuple[str, str]] styles = [<"padding", 
                                      "<round(f.padding[1])>px <round(f.padding[2])>px <round(f.padding[3])>px <round(f.padding[0])>px">];
     if (f.borderWidth>=0) styles += <"border-width", "<f.borderWidth>px">;
     if (!isEmpty(f.borderColor)) styles+= <"border-color", "<f.borderColor>">;
     if (!isEmpty(f.borderStyle)) styles+= <"border-style", "<f.borderStyle>">;
     if (htmlText(_):=f) {
          if(f.width>=0)  styles+= <"max-width", "<f.width>px">;
          if(f.height>=0)  styles+= <"max-height", "<f.height>px">;
          if(f.width>=0)  styles+= <"min-width", "<f.width>px">;
          if(f.height>=0)  styles+= <"min-height", "<f.height>px">;
          }
     list[value] tdArgs =[salix::HTML::style(styles)];
     tdArgs += hAlign(f.align);
     tdArgs += vAlign(f.align); 
     tdArgs+=[salix::HTML::style(styles)];
     list[value] tableArgs = foreignObjectArgs+TextModelToProperties(f, false); 
     if(str s:=v) foreignObject(foreignObjectArgs+[(){table(tableArgs+[(){tr((){td(tdArgs+[s]);});}]);}]);
    }
    
 void eval(Figure f:svgText(value v)) {
     if(str s:=v) text_(TextModelToProperties(f, true)+[s]);
    }
    
void eval(Figure f:vcat()) {
                   list[value] foreignObjectArgs = [style(<"line-height", "0">)];
                   foreignObject(foreignObjectArgs+[(){salix::HTML::table(fromTableModelToProperties(f)+[tableRows(f)]);}]);
                   }
                   
void eval(Figure f:hcat()) {
                   list[value] foreignObjectArgs = [style(<"line-height", "0">)];
                   foreignObject(foreignObjectArgs+[(){salix::HTML::table(fromTableModelToProperties(f)+[tableRows(f)]);}]);
                   }
 

void eval(Figure f:grid()) {
                   list[value] foreignObjectArgs = [style(<"line-height", "0">)];
                   foreignObject(foreignObjectArgs+[(){salix::HTML::table(fromTableModelToProperties(f)+[tableRows(f)]);}]);
                   }
     