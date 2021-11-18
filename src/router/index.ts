import { createRouter, createWebHistory, RouteRecordRaw } from 'vue-router'
import store from '@/store'
import SignIn from '@/views/SignIn.vue'

const routes: Array<RouteRecordRaw> = [
  {
    path: '/',
    name: 'SignIn',
    component: SignIn,
  },
  {
    path: '/account',
    name: 'Account',
    component: () => import('@/views/Account.vue'),
  },
  {
    path: '/new',
    name: 'New',
    component: () => import('@/views/New.vue'),
  },
  {
    path: '/newaccount',
    name: 'NewAccount',
    component: () => import('@/views/NewAccount.vue'),
  },
  {
    path: '/neworg',
    name: 'NewOrg',
    component: () => import('@/views/NewOrg.vue'),
  },
  {
    path: '/newproject',
    name: 'NewProject',
    component: () => import('@/views/NewProject.vue'),
  },
]

const router = createRouter({
  history: createWebHistory(process.env.BASE_URL),
  routes,
})

router.beforeEach((to, _from, next) => {
  if (to.name !== 'SignIn' && !store.state.account.address) {
    next({ name: 'SignIn' })
  } else {
    next()
  }
})

export default router
