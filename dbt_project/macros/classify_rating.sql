{% macro classify_rating(rating_column) %}
    case
        when {{ rating_column }} is null then 'Unrated'
        when {{ rating_column }} < 4.5 then 'Below 4.5'
        when {{ rating_column }} <= 4.8 then '4.5 - 4.8'
        else 'Above 4.8'
    end
{% endmacro %}