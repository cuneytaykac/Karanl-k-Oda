def runs(l):
    r=[];c=0
    for x in l:
        if x:c+=1
        elif c:r.append(c);c=0
    if c:r.append(c)
    return r
U,F,E=0,1,2
def solve_line(clue,line):
    n=len(line);cf=[False]*n;ce=[False]*n;memo={}
    def fits(b,pos):
        k=(b,pos)
        if k in memo:return memo[k]
        if b==len(clue):
            ok=all(line[i]!=F for i in range(pos,n))
            if ok:
                for i in range(pos,n):ce[i]=True
            memo[k]=ok;return ok
        L=clue[b];ok=False;start=pos
        while start+L<=n:
            if start>pos and line[start-1]==F:break
            if any(line[i]==E for i in range(start,start+L)):start+=1;continue
            end=start+L
            if end<n and line[end]==F:start+=1;continue
            np_=end+1 if end<n else end
            if fits(b+1,np_):
                ok=True
                for i in range(pos,start):ce[i]=True
                for i in range(start,end):cf[i]=True
                if end<n:ce[end]=True
            start+=1
        memo[k]=ok;return ok
    if not fits(0,0):return None
    return [U if cf[i] and ce[i] else (F if cf[i] else E) for i in range(n)]
def solve(rows):
    h=len(rows);w=len(rows[0]);sol=[[c=='#' for c in r] for r in rows]
    rc=[runs(r) for r in sol];cc=[runs([sol[r][c] for r in range(h)]) for c in range(w)]
    g=[[U]*w for _ in range(h)];ch=True
    while ch:
        ch=False
        for r in range(h):
            nx=solve_line(rc[r],g[r])
            if nx is None:return 'contra'
            if nx!=g[r]:g[r]=nx;ch=True
        for c in range(w):
            col=[g[r][c] for r in range(h)];nx=solve_line(cc[c],col)
            if nx is None:return 'contra'
            if nx!=col:
                for r in range(h):g[r][c]=nx[r]
                ch=True
    unk=sum(x==U for r in g for x in r)
    ok=all((g[r][c]==F)==sol[r][c] for r in range(h) for c in range(w))
    return unk,ok
