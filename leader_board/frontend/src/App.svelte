
<script>
    const url = "http://new.einardarri.is:5000/board/"

    async function getData() {
        const data = await fetch(url);
        const json = await data.json();
        players = sortData(json.data);
    }

    function sortData(data) {
        data.sort((a, b) => a.level - b.level);
        const a = data.filter(v => v.finished);
        const b = data.filter(v => !v.finished);
        a.push(...b);
        return a;
    }

    function leftPad(num, pad, amt) {
        let numstr = num.toString();
        for (let i = numstr.length; i < amt; i++) {
            numstr = pad + numstr;
        }
        return numstr
    }

    function formatDate(time) {
        const datetime = new Date(time);
        const date = leftPad(datetime.getDate(), "0", 2);
        const month = leftPad(datetime.getMonth(), "0", 2);
        const year = datetime.getFullYear();
        return `${date}/${month}/${year}`;
    }

    function formatTime(time) {
        const datetime = new Date(time);
        const hours = leftPad(datetime.getHours(), "0", 2);
        const minutes = leftPad(datetime.getMinutes(), "0", 2);
        return `${hours}:${minutes}`;
    }
    
    $effect(() => { getData(); });

    setInterval(() => { getData(); }, 60 * 1000);

    var players = $state([]);
</script>

<main>
    <table class="uk-table">
        <caption>Leaderboard</caption>
        <thead>
            <tr>
                <th>User</th>
                <th>Finished</th>
                <th>Level</th>
                <th>Total XP</th>
                <th>Damage taken</th>
                <th>Damage dealt</th>
                <th>Enemies killed</th>
                <th>Abilities picked</th>
                <th>Boss kills</th>
                <th>Heal amount (regen)</th>
                <th>Heal amount (medkits)</th>
                <th>Num crits</th>
                <th>Caught fish</th>
                <th>Shots fired</th>
                <th>Submission Date</th>
                <th>Submission Time</th>
            </tr>
        </thead>
        <tbody>
            {#each players as player}
                <tr>
                    <td>{player.username}</td>
                    <td>{player.finished ? "Yes" : "No"}</td>
                    <td>{player.level}</td>
                    <td>{player.total_xp}</td>
                    <td>{player.total_damage_taken}</td>
                    <td>{player.total_damage_done}</td>
                    <td>{player.kills}</td>
                    <td>{player.abilities_picked}</td>
                    <td>{player.boss_kills}</td>
                    <td>{player.heal_amount_regen}</td>
                    <td>{player.heal_amount_medkit}</td>
                    <td>{player.crits}</td>
                    <td>{player.caught_fish}</td>
                    <td>{player.shots_fired}</td>
                    <td>{formatDate(player.time)}</td>
                    <td>{formatTime(player.time)}</td>
                </tr>
            {/each}
        </tbody>
        <tfoot>
            <tr>
                <th>User</th>
                <th>Finished</th>
                <th>Level</th>
                <th>Total XP</th>
                <th>Damage taken</th>
                <th>Damage dealt</th>
                <th>Enemies killed</th>
                <th>Abilities picked</th>
                <th>Boss kills</th>
                <th>Heal amount (regen)</th>
                <th>Heal amount (medkits)</th>
                <th>Num crits</th>
                <th>Caught fish</th>
                <th>Shots fired</th>
                <th>Submission Date</th>
                <th>Submission Time</th>
            </tr>
        </tfoot>
    </table>
</main>
