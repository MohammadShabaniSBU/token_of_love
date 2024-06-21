import { defineStore } from "pinia";
import { ref, watch } from 'vue'
import { contractABI, contractAddress } from '../contract'
import Web3 from 'web3'
import { useActionsStore } from "./actions";

export const useWeb3Store = defineStore('web3', () => {
  const web3 = ref(null)
  const contract = ref(null)
  const account = ref(null)
  const accounts = ref([])
  const allowance = ref(0)

  const init = async () => {
    if (window.ethereum) {
      web3.value = new Web3(new Web3.providers.HttpProvider('http://localhost:8545'));

      accounts.value = await web3.value.eth.getAccounts()
      
      account.value = accounts.value[0]

      console.log('account', accounts)

      contract.value = new web3.value.eth.Contract(contractABI, contractAddress)

      useActionsStore().getAllowance()
    }
  }

  const setAllowance = (val) => {
    allowance.value = val
  }

  watch(account, () => {
    useActionsStore().getAllowance()
  })

  return {
    init,
    contract,
    account,
    web3,
    accounts,
    allowance,
    setAllowance,
  }
})
