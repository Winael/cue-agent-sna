import React, { useState, useEffect } from 'react';
import Select from 'react-select';

const Filter = ({ onFilterChange }) => {
    const [filterOptions, setFilterOptions] = useState(null);
    const [selectedFilters, setSelectedFilters] = useState({
        roles: [],
        locations: [],
        skills: [],
        contracts: [],
        languages: [],
    });

    useEffect(() => {
        const fetchFilterOptions = async () => {
            try {
                const response = await fetch('/api/filter_options');
                const data = await response.json();
                setFilterOptions(data);
            } catch (error) {
                console.error("Error fetching filter options:", error);
            }
        };

        fetchFilterOptions();
    }, []);

    const handleFilterChange = (selectedOptions, filterType) => {
        const values = selectedOptions ? selectedOptions.map(option => option.value) : [];
        const newFilters = { ...selectedFilters, [filterType]: values };
        setSelectedFilters(newFilters);
        onFilterChange(newFilters);
    };

    if (!filterOptions) {
        return <div>Loading filters...</div>;
    }

    const formatOptions = (optionsArray) => {
        return optionsArray.map(option => ({ value: option, label: option }));
    };

    return (
        <div className="filter-container">
            {Object.entries(filterOptions).map(([filterType, options]) => (
                <div key={filterType} className="filter-group">
                    <h5>{filterType.charAt(0).toUpperCase() + filterType.slice(1)}</h5>
                    <Select
                        isMulti
                        options={formatOptions(options)}
                        onChange={(selected) => handleFilterChange(selected, filterType)}
                        value={formatOptions(selectedFilters[filterType])}
                        placeholder={`Select ${filterType}...`}
                        menuPortalTarget={document.body} // Added this line
                        styles={{
                            menuList: (provided) => ({
                                ...provided,
                                fontSize: '0.5em',
                            }),
                            option: (provided) => ({
                                ...provided,
                                fontSize: '0.5em',
                            }),
                            control: (provided) => ({
                                ...provided,
                                fontSize: '0.5em',
                            }),
                            multiValueLabel: (provided) => ({
                                ...provided,
                                fontSize: '0.5em',
                            }),
                            input: (provided) => ({
                                ...provided,
                                fontSize: '0.5em',
                            }),
                        }}
                    />
                </div>
            ))}
        </div>
    );
};

export default Filter;
