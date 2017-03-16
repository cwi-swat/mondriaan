module salix::demo::basic::Tests
import util::Math;
import shapes::Figure;
import salix::HTML;
import salix::Core;
import salix::App;
import salix::LayoutFigure;
import Prelude;

//-------------------------------------------------------------------MODEL--------------------------------------------------------------------------------

alias Model = list[int];

Model startModel = [];

data Msg
   = doIt()
   ;

Model update(Msg msg, Model m) {
         return m;
}

Model init() = startModel;

Figure stack1(Figure f) = vcat(align=centerMid, vgap=4, figs=[box(grow=1.2, fig=htmlText("\<pre\><figToString(f)>\</pre\>", size=<600, 60>, overflow="auto")
        , fillColor = "beige", lineWidth = 2, lineColor="black"), f]);
        
 Figure b(str color, num x, num y) =  box(size=<100, 100>, lineWidth=2, lineColor= "black", fillColor =color, at=<x, y>);
 
 Figure tests(Model m) {
     return vcat(borderWidth=4, borderColor="grey", borderStyle="groove", vgap=4, figs=  mapper(
        [
      overlay(figs=[b("red", 0, 0), b("blue",40, 0), b("yellow", 0, 40)])
      ,box(size=<100, 100>, fillColor ="green", lineWidth=2, lineColor="black")
        ,box(size=<80, 40>, lineColor="black", lineWidth=2, fig=htmlText("Hallo", fontSize=20, fontColor="darkred"), fillColor = "antiquewhite")
       ,box(fillColor="antiquewhite", lineWidth = 8, lineColor="blue", align = centerMid, grow  =1.0
              , fig = box( size=<200, 200>, fillColor = "gold", lineWidth = 8, lineColor = "red"))
      ,box(fig=box(size=<50, 50>,fillColor="yellow"),align= topLeft,grow = 1.5,fillColor = "antiquewhite", lineWidth = 2, lineColor="black")
      ,box(fig=box(size=<50, 50>,fillColor="yellow"),align= centerMid,grow = 1.5,fillColor = "antiquewhite", lineWidth = 2, lineColor="black")
      ,box(fig=box(size=<50, 50>,fillColor="yellow"),align= bottomRight,grow = 1.5,fillColor = "antiquewhite", lineWidth = 2, lineColor="black")
      ,box(size=<75,75>, fig= box(shrink=0.666, fillColor = "yellow"), align = topLeft, fillColor= "antiquewhite", lineColor="black", lineWidth=2)
      ,box(size=<75,75>, fig= box(shrink=0.666, fillColor = "yellow"), align = centerMid, fillColor= "antiquewhite", lineColor="black",lineWidth=2)
       ,box(size=<75,75>, fig= box(shrink=0.666, fillColor = "yellow"), align = bottomRight, fillColor= "antiquewhite", lineColor="black", lineWidth=2)
       ,box(size=<75,75>, fig= circle(shrink=0.666, fillColor = "yellow", lineWidth=2, lineColor="brown"), align = centerMid, fillColor= "antiquewhite", lineColor="black",lineWidth=2)
        
        ,hcat(figs=[box(size=<30, 30>, fillColor="antiquewhite"), box(size=<50, 50>, fillColor="yellow"), box(size=<70, 70>, fillColor=  "red")],align= topLeft, borderWidth = 0, lineWidth =0, hgap=0)
        ,hcat(figs=[box(size=<30, 30>, fillColor="antiquewhite"), box(size=<50, 50>, fillColor="yellow"), box(size=<70, 70>, fillColor=  "red")],align= centerMid, lineWidth=0, hgap=0, borderWidth = 0)
        ,hcat(figs=[box(size=<30, 30>, fillColor="antiquewhite"), box(size=<50, 50>, fillColor="yellow"), box(size=<70, 70>, fillColor=  "red")],align= bottomRight, lineWidth =0, hgap=0, borderWidth = 0)
        ,hcat(width=210, height=90, figs= [box(shrink= 1.0, fillColor= "blue"), box(shrink= 0.7, fillColor= "yellow"), box(shrink=1.0, fillColor= "red")], align = bottomRight, hgap=0, borderWidth = 0)
        ,vcat(width=200, height=70, figs= [box(shrink= 1.0, fillColor= "blue"), box(shrink= 0.5, fillColor= "yellow"), box(shrink=1.0, fillColor= "red")], align = bottomLeft)
        ,vcat(size=<200, 60>, figs=[htmlText("a",align=centerRight, fontSize=14, fontColor="blue"), htmlText("bb",align=centerRight,fontSize=14, fontColor="blue"),htmlText("ccc",align=centerRight,fontSize=14, fontColor="blue")])
        ,grid(width=200, height=70, figArray= [[box(shrink= 0.5, fillColor="blue")], [box(shrink=0.3, fillColor="yellow"), box(shrink=0.5, fillColor="red")]], align=bottomLeft)
      //  ,grid(width=200, height=70, figArray= [[box(shrink= 0.5, fillColor="blue")], [box(shrink=0.3, fillColor="yellow"), box(shrink=0.5, fillColor="red")]], align=centerMid)
       // ,graph(width=200, height=200, nodes=[<"a", box(fig=text("aap",fontSize=14, fontColor="blue"), grow=1.6, fillColor="beige")>
       //                                  , <"b", box(fig=text("noot",fontSize=14, fontColor="blue"), grow=1.6, fillColor="beige")>]
       //                             ,edges=[edge("a","b")])
        ] , stack1)
        , resizable=true);
     } 
     
 void myView(Model m) {
    div(() {
        h2("Figure using SVG");
        fig(tests(m), width = 800);
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