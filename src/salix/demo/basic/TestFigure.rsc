module salix::demo::basic::TestFigure
import util::Math;
import shapes::Figure;
import salix::HTML;
import salix::Core;
import salix::App;
import salix::LayoutFigure;

//-------------------------------------------------------------------MODEL--------------------------------------------------------------------------------

alias Model = tuple[bool state, str innerFill1, str innerFill2, num middleGrow, Alignment align1, Alignment align2, int middleLineWidth, str label];

Model startModel = <false, "snow", "lightgrey", 1.2, bottomRight, topLeft, 8, "Hello\<br\>Dag">;

data Msg
   = doIt()
   //| newFace(int face)
   ;
   
Model update(Msg msg, Model m) {
    //do(command("alert", encode(msg), args = ("text": "aap")));
    // do(random(newFace, 1, 6));
    switch (msg) {
       case doIt(): 
          if (m.state) {
              m = startModel;         
              }
          else {
              str swap = m.innerFill2;
              m.innerFill2 = m.innerFill1;
              m.innerFill1 = swap;
              m.middleGrow = 1.5;
              Alignment q = m.align2;
              m.align2 = m.align1;
              m.align1 = q;
              m.middleLineWidth = 4;
              m.state = true;
              m.label = "Hallo\<br\>World";
              }
         case newFace(int n):;
         }
         return m;
}

Model init() = startModel;

//-------------------------------------------------------------------VIEW---------------------------------------------------------------------------------

Figure testFigure(Model m) {
    Figure down(str innerFill)  =  circle(r=25,fillColor=innerFill, lineWidth  = 4, lineColor="magenta");
    Figure middle(Alignment align, str innerFill) = box(fig = down(innerFill), grow=m.middleGrow, fillColor="antiquewhite",lineWidth =  m.middleLineWidth, lineColor="green", align=align);
    Figure top (Alignment align, str innerFill)  =   box(fig=middle(align, innerFill), grow=1.4, fillColor="lightyellow", lineWidth = 16, lineColor="brown"
                                                   , padding=<4, 4, 4, 4>, at=<0, 0>);
    return box(lineWidth=4, fig = 
           grid(borderWidth = 4,  vgap=2, hgap = 2, borderStyle="solid", align = topLeft, figArray=
             [
              [top(m.align1, m.innerFill1), top(m.align2, m.innerFill2)]
              ,[top(m.align1, m.innerFill2), top(m.align2, m.innerFill1)]
              ,[box(lineWidth=4, lineColor="brown", fig = 
                  shapes::Figure::ellipse(/*rx=50, ry = 30,*/ width=100, height = 60,  lineWidth=2, lineColor="blue", fillColor="lightgreen"
                       , fig=svgText("text", fontSize=30, /*fontLineWidth = 2.0,*/ fontColor="darkred", fontWeight="bold")
                   )
                   )
                ,box(lineWidth=2, lineColor="darkred",fig=circle(lineWidth=4, lineColor="gold", fig=box(lineWidth=2, lineColor="red",  width=50, height=50)))
               ],      
              [box(align=topLeft, fig=htmlText(m.label, fontColor="black", fontWeight="bold"), lineWidth= 2, lineColor="darkred", width=80, height=80)]
             ])
            , lineColor="red")
           ;
    } 
    
 
void myView(Model m) {
    div(() {
        h2("Figure using SVG");
        fig(testFigure(m), width = 600, height = 700);
        salix::HTML::div(() {salix::HTML::button(salix::HTML::onClick(doIt()), "On/Off");});
        });
    }
    
//---------------------------------------------------------------------------------------------------------------------------------------------------------

App[Model] testApp() {
   return app(init, myView, update, 
    |http://localhost:9103|, |project://mondriaan/src|);
   }
   
public App[Model] c = testApp();

public void main() {
     c.stop();
     c.serve();
     }

