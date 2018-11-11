module ApplicationHelper

    def nav_item_class(path)
        classes = ["nav-item"]
        if current_page?(path)
            classes << 'active'
        end
        return classes.join(' ')
    end

end
