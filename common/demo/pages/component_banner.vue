<template>
    <div class="app">

        <navbar class="navbar">
            <navbar-item type="back"></navbar-item>
            <navbar-item type="title">
                <text class="title">轮播控件</text>
            </navbar-item>
            <navbar-item type="right" @click="viewCode('component/banner')">
                <icon content="md-code-working" class="iconr"></icon>
            </navbar-item>
        </navbar>

        <banner class="banner" @itemClick="itemClick">
            <div class="banner-frame" v-for="img in imageList">
                <image class="banner-image" resize="cover" :src="img.src"></image>
            </div>
        </banner>

    </div>
</template>

<style scoped>
    .app {
        width: 750px;
        flex: 1;
        background-color: #ffffff;
    }

    .navbar {
        width: 750px;
        height: 100px;
    }

    .title {
        font-size: 28px;
        color: #ffffff
    }

    .iconr {
        width: 100px;
        height: 100px;
        color: #ffffff;
    }

    .banner {
        width: 750px;
        height: 420px;
    }

    .banner-frame {
        width: 750px;
        height: 420px;
        position: relative;
    }

    .banner-image {
        width: 750px;
        height: 420px;
    }

</style>

<script>
    const eeui = app.requireModule('eeui');

    export default {
        data() {
            return {
                imageList: [
                    { src: 'https://gd2.alicdn.com/bao/uploaded/i2/T14H1LFwBcXXXXXXXX_!!0-item_pic.jpg'},
                    { src: 'https://gd1.alicdn.com/bao/uploaded/i1/TB1PXJCJFXXXXciXFXXXXXXXXXX_!!0-item_pic.jpg'},
                    { src: 'https://gd3.alicdn.com/bao/uploaded/i3/TB1x6hYLXXXXXazXVXXXXXXXXXX_!!0-item_pic.jpg'}
                ]
            }
        },

        methods: {
            viewCode(str) {
                this.openViewCode(str);
            },

            itemClick(res) {
                eeui.toast("点击" + (res.position + 1) + "项")
            }
        }
    };
</script>
