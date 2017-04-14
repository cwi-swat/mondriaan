module salix::demo::basic::Schoolplot

import util::Math;
import shapes::Figure;
import salix::HTML;
import salix::Core;
import salix::App;
import salix::LayoutFigure;
import salix::Slider;

alias Model = list[tuple[num side]];

num startSide = 400;


Model startModel = [<startSide>];

data Msg
   = resize(int id, real x)
   ;
   
 Model update(Msg msg, Model m) {
    switch (msg) {
       case resize(_, real x): m[0].side = x;
       }
     return m;
}

Model init() = startModel;

Figure testFigure(Model m) {
     return thePlot(m);
     // return plot3();
     }
     
void myView(Model m) {
    div(() {
        h2("Figure using SVG");
        fig(testFigure(m)// , width = m[0].side+100, height = m[0].side+100
        );
        num lo = 200, hi = 1000;
        list[list[list[SliderBar]]] sliderBars = [[
                             [
                              < resize, 0, "resize:", lo, hi, 50, startSide,"<lo>", "<hi>"> 
                             ]
                             ]];
        slider(sliderBars);
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
     
 list[str] innerGridH(int n) {
     num s = 1.0/n;
     return [p_.M(0, y), p_.L(1, y)|y<-[s,2*s..1]];
     }
     
list[str] innerGridV(int n) {
     num s = 1.0/n;
     return [p_.M(x, 0), p_.L(x, 1)|x<-[s,2*s..1]];
     }

list[str] innerSchoolPlot1() {
     num s =0.5;
     return [p_.M(10, 10-i), p_.L(10-i, 0)|i<-[s,s+0.5..10]];
     }
     
list[str] innerSchoolPlot2() {
     num s = 0.5;
     return [p_.M(i, 10), p_.L(0, i)|i<-[s,s+0.5..10]];
     }
   
 Figure schoolPlot(Model g) {
     tuple[num side] m  =g[0];
     num r = m.side;
     return  overlay(lineWidth=1, width = m.side, height = m.side, figs = [
        shapes::Figure::path(innerSchoolPlot1()+innerSchoolPlot2(), fillColor = "none",
        viewBox=<0, 0, 10, 10>, // width = 400, height = 400, 
        lineColor = "blue")
         , 
       at(150*m.side/400, 150*m.side/400, shapes::Figure::circle(r=r/10,  fillColor = "yellow"
        ,lineWidth = 10, lineColor = "red", lineOpacity=0.5, fillOpacity=0.5, fig = htmlText("Hello")
        ))
        ,
       at(50*m.side/400, 50*m.side/400, shapes::Figure::circle(lineWidth=10, lineColor= "red", fillColor = "none",  fig= at(0,0, 
             box(width=50*m.side/400, height = 50*m.side/400, lineColor="grey", lineWidth = 10, fillColor = "antiquewhite")
            )))
        ,at(250*m.side/400, 250*m.side/400, shapes::Figure::circle(lineWidth=10, grow=1.0, fillColor="none", lineColor="brown"
        ,fig=ngon(n=7, r=r/10, lineWidth = 10, lineColor = "grey", fillColor = "none")))
        ])
        ;
     } 

Figure simpleGrid(Figure f) {
     return overlay(fillColor="none"//  , width = 400, height = 400
             , figs=[
        // box(lineWidth=0, lineColor="black", fig=
          shapes::Figure::path(innerGridV(10)+innerGridH(10) 
             /*,size=<398, 398>,*/ viewBox=<0, 0, 1, 1>, fillColor = "none",
              lineColor = "lightgrey", lineWidth = 1)
       // , fillColor = "none")
        , f
        ]
     );
     }
     
Figure labeled(Model m, Figure g) {
     return hcat(lineWidth = 0, 
        figs = [
           vcat(figs=gridLabelY(m), padding_bottom=20)
           , vcat(lineWidth = 0, figs = [box(fig=g, lineWidth=4, lineColor="grey"),
           hcat(figs = gridLabelX(m))])
           ]);
     }
     
 list[Figure] gridLabelX(Model m) {
     return [box(lineWidth = 0, lineColor = "none", width =  m[0].side/10, height = m[0].side/20, fig = htmlText("<i>"))|i<-[1..10]];
     }
     
 list[Figure] gridLabelY(Model m) {
     return [box(lineWidth = 0, lineColor = "none", width = m[0].side/10, height = m[0].side/10, fig = htmlText("<i>"))|i<-[9..0]];
     }
     
 Figure labeledGrid(Model m, Figure f) {
    return labeled(m, simpleGrid(f));   
    }
    
 Figure thePlot(Model m) = labeledGrid(m, simpleGrid(schoolPlot(m)));
 
 Figure plot3() = shapes::Figure::circle(lineWidth=10, fillColor="none", lineColor="brown"
        ,fig=ngon(n=7, r=40, lineWidth = 10, lineColor = "grey", fillColor = "none"));
   
