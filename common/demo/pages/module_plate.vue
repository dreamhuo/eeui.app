<template>
    <div class="app">

        <navbar class="navbar">
            <navbar-item type="back"></navbar-item>
            <navbar-item type="title">
                <text class="title">剪切板</text>
            </navbar-item>
            <navbar-item type="right" @click="viewCode('module/plate')">
                <icon content="md-code-working" class="iconr"></icon>
            </navbar-item>
        </navbar>

        <div class="content">
            <input class="inPut" v-model="text"/>
            <text class="button" @click="copyText">复制文本到剪贴板</text>
            <text class="button" @click="pasteText">获取剪贴板的文本</text>
        </div>

    </div>
</template>

<style>
    .app {
        width: 750px;
        flex: 1;
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

    .content {
        flex: 1;
        justify-content: center;
        align-items: center;
    }

    .inPut {
        font-size: 26px;
        width: 650px;
        height: 80px;
        margin-bottom: 30px;
        padding-top: 10px;
        padding-bottom: 10px;
        padding-left: 10px;
        padding-right: 10px;
        border-width: 1px;
        border-style: solid;
        border-color: #65b4d8;
    }

    .button {
        width: 380px;
        font-size: 24px;
        text-align: center;
        margin-top: 20px;
        margin-bottom: 20px;
        padding-top: 26px;
        padding-bottom: 26px;
        padding-left: 30px;
        padding-right: 30px;
        color: #ffffff;
        background-color: #00B4FF;
    }
</style>

<script>
    const eeui = app.requireModule('eeui');

    export default {
        data() {
            return {
                text: '',
            }
        },

        mounted() {
            this.text = '随机字符' + this.randomString(6);
        },
        methods: {
            viewCode(str) {
                this.openViewCode(str);
            },
            randomString(len) {
                len = len || 32;
                let $chars = 'ABCDEFGHJKMNPQRSTWXYZabcdefhijkmnprstwxyz2345678oOLl9gqVvUuI1';
                let maxPos = $chars.length;
                let pwd = '';
                for (let i = 0; i < len; i++) {
                    pwd += $chars.charAt(Math.floor(Math.random() * maxPos));
                }
                return pwd;
            },

            copyText() {
                eeui.copyText(this.text);
                eeui.toast("复制成功");
            },
            pasteText() {
                let variable = eeui.pasteText();
                eeui.toast("获取剪贴板：" + variable);
            },
        }
    };
</script>
