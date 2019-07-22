<template>
    <div class="app">
        <scroller class="list">

            <text class="list-title">预设样式</text>

            <div class="list-item">
                <button class="button" :eeui="{text:'默认'}" @click='goBanner'></button>
                <button class="button" :eeui="{text:'红色', model:'red'}"></button>
            </div>
        </scroller>
    </div>

</template>

<style scoped>
   .app {
        width: 750px;
        flex: 1;
        background-color: #ffffff;
    }

    .list {
        width: 750px;
        flex: 1;
    }

    .list-title {
        margin-top: 24px;
        margin-bottom: 12px;
        padding-top: 36px;
        padding-right: 24px;
        padding-bottom: 24px;
        padding-left: 24px;
        font-size: 28px;
        color: #757575;
    }

    .list-item {
        width: 750px;
        flex-direction: row;
    }

    .button {
        font-size: 24px;
        margin-left: 37.5px;
        margin-right: 37.5px;
        margin-bottom: 20px;
        width: 300px;
        height: 80px;
    }

    .list-input-item {
        width: 750px;
        height: 90px;
        flex-direction: row;
        align-items: center;
        border-bottom-color: #e4e4e4;
        border-bottom-style: solid;
        border-bottom-width: 1px;
    }

    .cell {
        padding-left: 50px;
        font-size: 24px;
        color: #666666;
    }

    .switch {
        margin-right: 40px;
    }

    .input {
        padding-right: 50px;
        flex: 1;
        height: 90px;
        text-align: right;
        font-size: 28px;
    }

    .demo-item {
        width: 750px;
        padding-top: 30px;
        padding-bottom: 30px;
        align-items: center;
    }
</style>

<script>
  const eeui = app.requireModule('eeui');

    export default {

        methods: {
            goBanner(res) {
                //示例②
                eeui.openPage({
                    pageName: 'banner',
                    pageType: 'app',
                    url: 'banner.js'
                }, function(result) {
                    eeui.toast("到banner页看一看")
                });
            }
        }
    };
</script>
