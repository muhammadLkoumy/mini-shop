import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:shop/models/search_model.dart';
import 'package:shop/modules/search/bloc/cubit.dart';
import 'package:shop/modules/search/bloc/states.dart';
import 'package:shop/shared/components/component.dart';

class SearchScreen extends StatelessWidget {
  SearchScreen({Key? key}) : super(key: key);

  final searchController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SearchCubit, SearchStates>(
      listener: (context, state) {
        if (state is SearchSuccessState) {}
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('SEARCH'),
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
              ),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextFormField(
                  controller: searchController,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search),
                    label: const Text('Search'),
                    border: const OutlineInputBorder(),
                    suffix: SizedBox(
                      width: 50,
                      child: InkWell(
                        onTap: () {
                          SearchCubit.get(context).search(text: searchController.text);
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: const [
                            Text('Go', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),),
                            Icon(Icons.arrow_forward_ios, color: Colors.blue,),
                          ],
                        ),
                      ),
                    ),
                  ),
                  keyboardType: TextInputType.text,
                  validator: (value){
                    if (value == null) {
                      return 'Enter a product to search!';
                    }
                    return null;
                  },
                  onFieldSubmitted: (text) {
                    SearchCubit.get(context).search(text: text);
                  },
                ),
                if (state is SearchLoadingState)
                  const LinearProgressIndicator(
                    backgroundColor: Colors.orange,
                  ),
                const SizedBox(
                  height: 5,
                ),
                if (state is SearchSuccessState)
                  Expanded(
                    child: ListView.separated(
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, index) => _product(
                          SearchCubit.get(context)
                              .searchModel!
                              .data!
                              .data[index],
                          context),
                      separatorBuilder: (context, index) => separator(),
                      itemCount: SearchCubit.get(context)
                          .searchModel!
                          .data!
                          .data
                          .length,
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _product(SearchProduct model, context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Stack(
              alignment: Alignment.bottomLeft,
              children: [
                Image(
                  image: NetworkImage(
                    '${model.image}',
                  ),
                  height: 100,
                  width: 100,
                ),
              ],
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: SizedBox(
              height: 100,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      '${model.name}',
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyText1!.copyWith(
                            fontSize: 12,
                            height: 1.3,
                            color: Colors.black87,
                          ),
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        '${model.price}',
                        style: Theme.of(context).textTheme.bodyText1!.copyWith(
                              fontSize: 14,
                              color: Colors.blue,
                            ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      const Spacer(),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
