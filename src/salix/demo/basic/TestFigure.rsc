module salix::demo::basic::TestFigure
import shapes::Figure;
import salix::HTML;
import salix::App;
import salix::LayoutFigure;

alias Model = tuple[str innerFill, num middleGrow];

data Msg
   = doIt()
   ;

Figure testFigure(Model m) {
    Figure down =  box(event=onclick(doIt()), width=50, height = 50,
                                 fillColor=m.innerFill,        lineWidth  = 4, lineColor="magenta");
    Figure middle= box(grow=m.middleGrow, fillColor="antiquewhite",lineWidth =  8, lineColor="green", align=bottomRight, fig = down);
    Figure top =   
             box(grow=1.4, fillColor="lightyellow", lineWidth = 16, lineColor="brown" ,align=topLeft,     fig=middle
             , padding=<10, 10, 10, 10>);
    return top;
    }    


void myView(Model m) {
    div(() {
        h2("Figure using SVG");
        fig(testFigure(m));
        });
    }
    
Model init() = <"snow", 1.2>;

Model update(Msg msg, Model m) {
    switch (msg) {
       case doIt(): 
          if (m.innerFill=="snow") {
              m.innerFill= "lightgrey";
              m.middleGrow = 1.5;
              }
          else {
              m.innerFill = "snow";
              m.middleGrow = 1.2;
              }
         }
         return m;
}

App[Model] testApp() {
   return app(init, myView, update, 
    |http://localhost:9103|, |project://salix/src|);
   }
   
public App[Model] c = testApp();

