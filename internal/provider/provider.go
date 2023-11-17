// Copyright (c) HashiCorp, Inc.
// SPDX-License-Identifier: MPL-2.0

package provider

import (
	"context"

	"github.com/hashicorp/terraform-plugin-framework/datasource"
	"github.com/hashicorp/terraform-plugin-framework/provider"
	"github.com/hashicorp/terraform-plugin-framework/provider/schema"
	"github.com/hashicorp/terraform-plugin-framework/resource"
)

// Ensure TTFProvider satisfies various provider interfaces.
var _ provider.Provider = &TTFProvider{}

// TTFProvider defines the provider implementation.
type TTFProvider struct {
	// version is set to the provider version on release, "dev" when the
	// provider is built and ran locally, and "test" when running acceptance
	// testing.
	version string
	store   *ProviderStore
}

// TTFProviderModel describes the provider data model.
type TTFProviderModel struct{}

func (p *TTFProvider) Metadata(ctx context.Context, req provider.MetadataRequest, resp *provider.MetadataResponse) {
	resp.TypeName = "ttf"
	resp.Version = p.version
}

func (p *TTFProvider) Schema(ctx context.Context, req provider.SchemaRequest, resp *provider.SchemaResponse) {
	resp.Schema = schema.Schema{
		Attributes: map[string]schema.Attribute{},
	}
}

func (p *TTFProvider) Configure(ctx context.Context, req provider.ConfigureRequest, resp *provider.ConfigureResponse) {
	var data TTFProviderModel

	resp.Diagnostics.Append(req.Config.Get(ctx, &data)...)

	if resp.Diagnostics.HasError() {
		return
	}

	resp.DataSourceData = p.store
	resp.ResourceData = p.store
}

func (p *TTFProvider) Resources(ctx context.Context) []func() resource.Resource {
	return []func() resource.Resource{
		NewFeatureResource,
		// Harnesses
		NewHarnessNullResource,
		NewHarnessK3sResource,
		NewHarnessTeardownResource,
		// Environments
		NewEnvironmentResource,
	}
}

func (p *TTFProvider) DataSources(ctx context.Context) []func() datasource.DataSource {
	return []func() datasource.DataSource{}
}

func New(version string) func() provider.Provider {
	return func() provider.Provider {
		return &TTFProvider{
			version: version,
			store:   NewProviderStore(),
		}
	}
}
