import { defineStore } from 'pinia'
import { useWeb3Store } from './web3'

export const useActionsStore = defineStore('actions', () => {

  const getAllowance = async () => {
    const res = await useWeb3Store().contract.methods.get_allowance().call({ from: useWeb3Store().account })

    useWeb3Store().setAllowance(res)
  }

  const setFriendAddress = async (friendAddr) => {
    const res = await useWeb3Store().contract.methods.weAreFriends(friendAddr).send({ from: useWeb3Store().account })
    console.log(res)
  }

  const cut = async () => {
    const res = await useWeb3Store().contract.methods.weCut().send({ from: useWeb3Store().account })
    console.log(res)

    getAllowance()
  }

  const mint = async () => {
    const res = await useWeb3Store().contract.methods.thoughtOfThem().send({ from: useWeb3Store().account })
    console.log(res)

    getAllowance()
  }

  return {
    mint,
    setFriendAddress,
    cut,
    getAllowance,
  }
})
