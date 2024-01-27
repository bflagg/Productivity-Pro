//
//  PPScrollView.swift
//  Productivity Pro
//
//  Created by Till Brügmann on 10.10.22.
//

import SwiftUI

@MainActor
struct PPScrollView<Content: View>: UIViewRepresentable {
    @Environment(ToolManager.self) var toolManager
    @Environment(SubviewManager.self) var subviewManager
    
    var isPortrait: Bool
    
    @Binding var scale: CGFloat
    @Binding var offset: CGPoint
    
    var content: () -> Content
    
    func makeUIView(context: Context) -> UIScrollView {
        let scrollView = UIScrollView()
        
        scrollView.delegate = context.coordinator
        scrollView.minimumZoomScale = 0.4
        scrollView.maximumZoomScale = 3
        scrollView.bouncesZoom = false
        scrollView.isScrollEnabled = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        
        let controller = context.coordinator.hostingController
        let hostedView = controller.view!
        hostedView.frame = CGRect(origin: .zero, size: getFrame())
        hostedView.backgroundColor = .secondarySystemBackground
        scrollView.addSubview(hostedView)
        scrollView.setZoomScale(scrollView.minimumZoomScale, animated: false)
        
        Task { @MainActor in scale = scrollView.zoomScale }
        return scrollView
    }
    
    func updateUIView(_ uiView: UIScrollView, context: Context) {
        let subView = uiView.subviews[0]

        let deltaWidth = uiView.bounds.size.width - uiView.contentSize.width
        let offsetX = CGFloat(max(deltaWidth * 0.5, 0.0))
        
        let deltaHeight = uiView.bounds.size.height - uiView.contentSize.height
        let offsetY = CGFloat(max(deltaHeight * 0.5, 0.0))

        subView.center = CGPoint(
            x: uiView.contentSize.width * 0.5 + offsetX,
            y: uiView.contentSize.height * 0.5 + offsetY
        )
        
        context.coordinator.hostingController.rootView = content()
        assert(context.coordinator.hostingController.view.superview == uiView)
    }
    
    func makeCoordinator() -> Coordinator {
        @Bindable var toolValue = toolManager
        
        return Coordinator(
            hostingController: UIHostingController(rootView: content()),
            scale: $scale,
            offset: $offset,
            editorVisible: $toolValue.editorVisible,
            frameVisible: $toolValue.frameVisible
        )
    }
    
    @MainActor
    final class Coordinator: NSObject, UIScrollViewDelegate {
        var hostingController: UIHostingController<Content>
        
        @Binding var scale: CGFloat
        @Binding var offset: CGPoint
        @Binding var editorVisible: Bool
        @Binding var frameVisible: Bool
        
        init(
            hostingController: UIHostingController<Content>,
            scale: Binding<CGFloat>, offset: Binding<CGPoint>,
            editorVisible: Binding<Bool>, frameVisible: Binding<Bool>
        ) {
            self.hostingController = hostingController
            _scale = scale
            _offset = offset
            _editorVisible = editorVisible
            _frameVisible = frameVisible
        }
        
        func scrollViewDidZoom(_ scrollView: UIScrollView) {
            let subView = scrollView.subviews[0]

            let deltaWidth = scrollView.bounds.size.width - scrollView.contentSize.width
            let offsetX = CGFloat(max(deltaWidth * 0.5, 0.0))
            
            let deltaHeight = scrollView.bounds.size.height - scrollView.contentSize.height
            let offsetY = CGFloat(max(deltaHeight * 0.5, 0.0))

            subView.center = CGPoint(
                x: scrollView.contentSize.width * 0.5 + offsetX,
                y: scrollView.contentSize.height * 0.5 + offsetY
            )
        }

        func viewForZooming(in scrollView: UIScrollView) -> UIView? {
            return hostingController.view
        }

        func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
            Task { @MainActor in
                editorVisible = false
                frameVisible = false
            }
        }
        
        func scrollViewDidEndZooming(
            _ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat
        ) {
            Task { @MainActor in
                self.scale = scrollView.zoomScale
                self.offset = scrollView.contentOffset
                
                editorVisible = true
                frameVisible = true
            }
        }
        
        func scrollViewDidEndDragging(
            _ scrollView: UIScrollView, willDecelerate decelerate: Bool
        ) {
            Task { @MainActor in
                offset = scrollView.contentOffset
            }
        }
        
        func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
            Task { @MainActor in
                offset = scrollView.contentOffset
            }
        }

        func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
            Task { @MainActor in
                offset = scrollView.contentOffset
            }
        }
    }
    
    func getFrame() -> CGSize {
        var frame: CGSize = .zero
        
        if isPortrait {
            frame = CGSize(width: shortSide, height: longSide)
        } else {
            frame = CGSize(width: longSide, height: shortSide)
        }
        
        return frame
    }
}
