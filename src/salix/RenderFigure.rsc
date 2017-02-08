module salix::RenderFigure
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

alias Model = map[Figure, tuple[num x, num y, int width, int height, str fill, int strokeWidth, str stroke
  , str visibility, Alignment align, Msg onclick]];
  
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
       
list[value] fromModelToProperties(Figure f, Model m) {
   list[value] r =[];
   r+= salix::SVG::x("<m[f].x>px");
   r+= salix::SVG::y("<m[f].y>px");
   if (m[f].width>=0) r+= salix::SVG::width("<m[f].width>px");
   if (m[f].height>=0) r+= salix::SVG::height("<m[f].height>px");
   if (!isEmpty(m[f].fill)) r+= salix::SVG::fill(m[f].fill);
   if (!isEmpty(m[f].stroke)) r+= salix::SVG::stroke(m[f].stroke);
   if (m[f].strokeWidth>=0) r+= salix::SVG::strokeWidth("<m[f].strokeWidth>px");
   if (!isEmpty(m[f].visibility)) r+= salix::SVG::visibility(m[f].visibility);
   if (Msg q:msg(_):= m[f].onclick)  r+=salix::SVG::onClick(q);
   return r;
   }
   
void() inner(Model m, Figure outer, Figure inner) {
    return (){
       int widtho = m[outer].width; int heighto = m[outer].height; 
       int widthi = m[inner].width; int heighti = m[inner].height; 
       int lwo = m[outer].strokeWidth; int lwi = m[inner].strokeWidth;
       if (lwo<0) lwo = 0; if (lwi<0) lwi = 0;
       list[value] svgArgs = [];
       if (widthi>=0) svgArgs+= salix::SVG::width("<widthi+lwi>px");
       if (heighti>=0) svgArgs+= salix::SVG::height("<heighti+lwi>px");
       list[value] foreignObjectArgs = [];
       if (widtho>=0) foreignObjectArgs+= salix::SVG::width("<widtho-lwo>px");
       if (heighto>=0) foreignObjectArgs+= salix::SVG::height("<heighto-lwo>px");
       if (widtho>=0) foreignObjectArgs+= salix::SVG::x("<lwo>px");
       if (heighto>=0) foreignObjectArgs+= salix::SVG::y("<lwo>px");
       list[value] tdArgs = [];
       if (widtho>=0) tdArgs+=salix::SVG::width("<widtho-lwo>px");
       if (heighto>=0) tdArgs+=salix::SVG::height("<heighto-lwo>px");
       tdArgs += hAlign(m[outer].align);
       tdArgs += vAlign(m[outer].align); 
       // tdArgs+= [salix::HTML::style(<"vertical-align", "bottom">)];
       m[inner].x+=lwi/2; m[inner].y+=lwi/2; 
       list[value] tableArgs = [salix::HTML::style(<"height", "<heighto-lwo>px">)];     
       foreignObject(foreignObjectArgs+[(){table(tableArgs+[(){tr((){td(tdArgs+[(){svg(svgArgs+[(){eval(inner, m);}]);}]);});}]);}]);};
    }
  
void eval(Figure f, Model m) {
    switch(f) {
        case emptyFigure():;
        case root(): svg(fromModelToProperties(f, m)+[() {eval(f.fig, m);}]);
        case box(): {
         \rect(fromModelToProperties(f, m)// +[() {eval(f.fig, m);}]
         );
         if (emptyFigure()!:=f.fig) inner(m, f, f.fig)();
         }
        }
    }
    
 Model createStartModel(list[Figure] fs) {
     Model r = (f:<f.at[0], f.at[1], f.width, f.height, f.fillColor, f.lineWidth, f.lineColor, f.visibility,
     f.align, noMsg()>|f<-fs); 
     for (f<-r) {
         switch(f) {
           case root(): {
                   Figure g = f.fig;
                   if (r[g].strokeWidth>=0 && r[g].width>=0 && r[g].height>=0) {
                   if (f.width<0 && f.height<0) {
                         r[f].width = r[g].width + r[g].strokeWidth;
                         r[f].height = r[g].height + r[g].strokeWidth;                  
                   }
                   r[g].x += r[g].strokeWidth/2;
                   r[g].y += r[g].strokeWidth/2;
              }     
            }
        }
        if (onclick(Msg msg):=f.event) r[f].onclick = msg;
        }
     return r;
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
     return fs+f;
     }
  
 
 App[Model] figApp(Figure f, Model(Msg, Model) update, int width = -1, int height = -1, int fillColor="") {
     Figure root = root(width = width, height = height, fillColor= fillColor);
     root.fig = f;
     Model startModel = createStartModel(getFigures([], root));
     Model init() {return startModel;}    
     void(Model) view(Figure f) {return void(Model m) {
       div(() {
          f.before();
          eval(root, m);
          f.after();
          });
        };
      };
  
  return app(init, view(f), update, 
    |http://localhost:9103|, |project://salix/src|);
   }
       

      
