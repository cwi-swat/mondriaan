module salix::demo::basic::TestFigure
import shapes::Figure;
import salix::HTML;
import salix::App;
import salix::LayoutFigure;

//-------------------------------------------------------------------MODEL--------------------------------------------------------------------------------

alias Model = tuple[bool state, str innerFill, num middleGrow, Alignment align, int middleLineWidth];

Model startModel = <false, "snow", 1.2, bottomRight, 8>;

data Msg
   = doIt()
   ;
   
Model update(Msg msg, Model m) {
    switch (msg) {
       case doIt(): 
          if (m.state) {
              m = startModel;         
              }
          else {
              m.innerFill= "lightgrey";
              m.middleGrow = 1.5;
              m.align= topLeft;
              m.middleLineWidth = 4;
              m.state = true;
              }
         }
         return m;
}

Model init() = startModel;

//-------------------------------------------------------------------VIEW---------------------------------------------------------------------------------

Figure testFigure(Model m) {
    Figure down =  box(width=50, height = 50,fillColor=m.innerFill, lineWidth  = 4, lineColor="magenta");
    Figure middle= box(fig = down, grow=m.middleGrow, fillColor="antiquewhite",lineWidth =  m.middleLineWidth, lineColor="green", align=m.align);
    Figure top =   box(fig=middle, grow=1.4, fillColor="lightyellow", lineWidth = 16, lineColor="brown", padding=<4, 4, 4, 4>);
    return box(lineWidth=4, fig = 
           grid(borderWidth = 4,  borderStyle="groove", figArray=[[top, top]])
            , lineColor="red", align = topLeft)
           ;
    }    

void myView(Model m) {
    div(() {
        h2("Figure using SVG");
        fig(testFigure(m), width = 600, height = 400);
        salix::HTML::div(() {salix::HTML::button(salix::HTML::onClick(doIt()), "On/Off");});
        });
    }
    
//---------------------------------------------------------------------------------------------------------------------------------------------------------

App[Model] testApp() {
   return app(init, myView, update, 
    |http://localhost:9103|, |project://salix/src|);
   }
   
public App[Model] c = testApp();

