<script lang="typescript">
  import portsData from "./data/ports";
  import cc from "camelcase-keys";
  import type { PortInfo } from "./models";

  const ports: PortInfo[] = cc(portsData) as PortInfo[];
  let shownPorts: PortInfo[] = [];
  let port = 0;
  let debounceTimer: number | undefined;

  $: {
    portValueChange(port);
  }

  function portValueChange(port: number) {
    clearTimeout(debounceTimer);
    debounceTimer = setTimeout(() => {
      if (!port) port = 0;
      if (port < 0) port = 0;
      if (port > 65535) port = 65535;
      console.log("The value changed to ", port);
      shownPorts = ports.filter((p) => p.portNumber === port);
      console.log(shownPorts);
    }, 100);
  }

  function getRandomInt(min: number, max: number): number {
    min = Math.ceil(min);
    max = Math.floor(max);
    return Math.floor(Math.random() * (max - min + 1)) + min;
  }
</script>

<span class="flex flex-col container mx-auto p-0 bg-gray-800 text-gray-500 h-screen w-screen">
  <div class="h-1/2 flex flex-col justify-center items-center">
    <h1 class="text-5xl mt-10">Port Selector</h1>
    <div class="w-full px-40 py-10">
      <input
        type="range"
        min="0"
        max="65535"
        bind:value={port}
        class="slider rounded appearance-none w-full h-4 bg-gray-500 outline-none opacity-70 transition-opacity hover:bg-opacity-100"
      />
    </div>
    <input min="0" max="65535" type="number" bind:value={port} class="text-5xl cursor-pointer bg-transparent text-center" />
    <span class="flex flex-row space-x-3 mb-1">
      <button
        class="p-3 mt-4 w-44 rounded-xl text-sm font-medium text-white bg-indigo-600 hover:bg-indigo-800 border-indigo-500 active:bg-grey-900 border-2 transition-all"
        on:click={() => {
          navigator.clipboard.writeText(port.toString());
        }}>Copy to Clipboard 📋</button
      >
      <button
        on:click={() => {
          port = getRandomInt(0, 65535);
        }}
        class="p-3 mt-4 w-44 rounded-xl text-sm font-medium text-white bg-indigo-600 hover:bg-indigo-800 border-indigo-500 active:bg-grey-900 focus:outline-none border-2 transition-all"
        >I am feeling lucky 🍀</button
      >
    </span>
  </div>
  <div class="flex flex-col justify-center items-center">
    {#if ports && shownPorts.length !== 0}
      <table class="border-collapse w-1/2 my-10">
        <thead>
          <tr>
            <th class="p-3 font-bold uppercase bg-gray-200 text-gray-600 border border-gray-300 hidden lg:table-cell">Port</th>
            <th class="p-3 font-bold uppercase bg-gray-200 text-gray-600 border border-gray-300 hidden lg:table-cell">Service</th>
            <th class="p-3 font-bold uppercase bg-gray-200 text-gray-600 border border-gray-300 hidden lg:table-cell">Protocol</th>
            <th class="p-3 font-bold uppercase bg-gray-200 text-gray-600 border border-gray-300 hidden lg:table-cell">Description</th>
          </tr>
        </thead>
        <tbody class="flex-1 sm:flex-none">
          {#each shownPorts as port, i}
            <tr class="bg-white lg:hover:bg-gray-100 flex lg:table-row flex-row lg:flex-row flex-wrap lg:flex-no-wrap mb-10 lg:mb-0">
              <td class="w-full lg:w-auto p-3 text-gray-800 text-center border border-b block lg:table-cell relative lg:static">
                <span class="lg:hidden absolute top-0 left-0 bg-blue-200 px-2 py-1 text-xs font-bold uppercase">Port</span>
                {port.portNumber || "-"}
              </td>
              <td class="w-full lg:w-auto p-3 text-gray-800 text-center border border-b block lg:table-cell relative lg:static">
                <span class="lg:hidden absolute top-0 left-0 bg-blue-200 px-2 py-1 text-xs font-bold uppercase">Service</span>
                {port.serviceName || "-"}
              </td>
              <td class="w-full lg:w-auto p-3 text-gray-800 text-center border border-b block lg:table-cell relative lg:static">
                <span class="lg:hidden absolute top-0 left-0 bg-blue-200 px-2 py-1 text-xs font-bold uppercase">Protocol</span>
                {port.transportProtocol || "-"}
              </td>
              <td class="w-full lg:w-auto p-3 text-gray-800 border border-b text-center block lg:table-cell relative lg:static">
                <span class="lg:hidden absolute top-0 left-0 bg-blue-200 px-2 py-1 text-xs font-bold uppercase">Description</span>
                {port.description || "-"}
              </td>
            </tr>
          {/each}
        </tbody>
      </table>
    {:else}
      <h1 class="text-5xl text-green-600 text-center">this one could be yours!</h1>
    {/if}
  </div>
  <span class="flex-grow" />
  <span class="flex flex-row space-x-3 w-full justify-center py-1">
    <button
      on:click={() =>
        alert(
          "This tool is for selecting a free port for new network applications. Given that there are 65536 of them the choice can be pretty hard. :)"
        )}>What's this ❓</button
    >
    <a href="https://www.iana.org/assignments/service-names-port-numbers" target="_blank">Database 🤓</a>
    <a href="https://ko-fi.com/alperalkan" target="_blank">Donate 💜</a>
  </span>
</span>

<style>
  h1 {
    font-family: "Exo";
  }
  .slider::-webkit-slider-thumb {
    -webkit-appearance: none;
    appearance: none;
    width: 3vh;
    height: 3vh;
    background: white;
    cursor: pointer;
    border-radius: 50%;
  }

  .slider::-moz-range-thumb {
    width: 3vh;
    height: 3vh;
    background: white;
    cursor: pointer;
    border-radius: 50%;
  }
</style>
