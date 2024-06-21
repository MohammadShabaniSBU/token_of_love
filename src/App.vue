<script setup>
import { useWeb3Store } from './stores/web3'
import { useActionsStore } from './stores/actions'
import { ref } from 'vue'
import { storeToRefs } from 'pinia'

const friendAddr = ref('')

const web3Store = useWeb3Store()
const { accounts, account, allowance } = storeToRefs(web3Store)

web3Store.init()

const actions = useActionsStore()
const { mint, setFriendAddress, cut, getAllowance } = actions

</script>

<template>
  <VContainer class="border rounded mt-6">
    <div class="d-flex justify-space-between">
      <div>
        Allowance: {{ allowance }}
      </div>
      <h2>
        Token Of Love
      </h2>
      <div>
        <VSelect v-model="account" :items="accounts" />
      </div>
    </div>

    <VRow class="mt-10">

      <VCol cols="4">
        <VCard variant="outlined" title="Get Token">
          <VCardText>
            <VBtn
              block
              color="primary"
              @click="mint"
            >
              Mint
            </VBtn>
          </VCardText>
        </VCard>
      </VCol>

      <VCol cols="4">
        <VCard variant="outlined" title="Set Friend Address">
          <VCardText>
            <VTextarea v-model="friendAddr" />

            <VBtn
              block
              color="primary"
              @click="() => setFriendAddress(friendAddr)"
            >
              Make Friend
            </VBtn>
          </VCardText>
        </VCard>
      </VCol>

      <VCol cols="4">
        <VCard variant="outlined" title="Cut">
          <VCardText>
            <VBtn
              block
              color="primary"
              @click="cut"
            >
              Cut With Friend
            </VBtn>
          </VCardText>
        </VCard>
      </VCol>

    </VRow>
  </VContainer>
</template>
