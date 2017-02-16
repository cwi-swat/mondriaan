module salix::demo::basic::Shapes
import salix::RenderFigure;
import shapes::Figure;
import salix::HTML;
import salix::App;

Model(Msg , Model) update(list[Figure] fs) {
  Figure top = fs[0];
  Figure middle= fs[1];
  Figure down = fs[2];
  return 
     Model(Msg msg, Model m) {
       if (msg(str key):= msg)
        switch (key) {
          case "click": 
            if (m[down].fill=="snow") {
                m[down].fill= "lightgrey";
                m[middle].grow = 1.5;
                m[top].padding.left=0;
                }
            else {
                m[down].fill = "snow";
                m[middle].grow = 1.2;
                m[top].padding.left=10;
                }
         }
         return m;
         };
}

App[Model] makeFig() {
    Figure down =  box(event=onclick(msg("click")), width=50, height = 50,
                                 fillColor="snow",        lineWidth  = 4, lineColor="magenta");
    Figure middle= box(grow=1.2, fillColor="antiquewhite",lineWidth =  8, lineColor="green", align=bottomRight, fig = down);
    Figure top =   
             box(grow=1.4, fillColor="lightyellow", lineWidth = 16, lineColor="brown" ,align=topLeft,     fig=middle
             , padding=<10, 10, 10, 10>);
  
    
    Figure root = grid(width=400, height = 400, borderWidth = 2, borderColor="black", borderStyle="solid", figArray=[[top]]);
    root.before= void() {return h2("Figure using SVG");};
    root.after = void(){return 
          salix::HTML::div(() {salix::HTML::button(salix::HTML::onClick(msg("click")), "On/Off");})
     ;};
    return figApp(root, update([top, middle, down])
    );
    }
    
public App[Model] c = makeFig();

    


