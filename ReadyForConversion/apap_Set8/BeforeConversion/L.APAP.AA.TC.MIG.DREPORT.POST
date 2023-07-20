*-----------------------------------------------------------------------------
* <Rating>-20</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE L.APAP.AA.TC.MIG.DREPORT.POST

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.DATES
    $INSERT LAPAP.BP I_L.APAP.AA.TC.MIG.DREPORT.COMMON

    GOSUB INIT
    GOSUB PROCESS
    RETURN

INIT:
****
    FN.L.APAP.TC.MIG.WORKFILE = 'F.L.APAP.TC.MIG.WORKFILE'; F.L.APAP.TC.MIG.WORKFILE = ''
    CALL OPF(FN.L.APAP.TC.MIG.WORKFILE,F.L.APAP.TC.MIG.WORKFILE)
    YTODAY = TODAY
    YFILE.NME = "Migracion.TC.castigadas_":YTODAY:".txt"
    YFILE.PATH  = "../bnk.interface/REG.REPORTS"
    FN.CHK.DIR = YFILE.PATH
    F.CHK.DIR = ''
    CALL OPF(FN.CHK.DIR,F.CHK.DIR)
    R.FIL = '';    FIL.ERR = ''
    CALL F.READ(FN.CHK.DIR,YFILE.NME,R.FIL,F.CHK.DIR,READ.FIL.ERR)
    IF R.FIL THEN
        DELETE F.CHK.DIR,YFILE.NME
    END
    RETURN

PROCESS:
********
    R.FILE.DATA = "id_cliente,fec_apertura,bce_capita,fec_castigo,numcuenta,numtarjeta,T24.ACCT,sucursal_t24,cap_vigent,int_vigente,cap_vencido,int_vencido,int_contin,comisiones,saldo"
    SEL.CMD = ''; ID.LIST = ""; ID.CNT = ''; ERR.SEL = ''
    SEL.CMD = "SELECT ":FN.L.APAP.TC.MIG.WORKFILE
    CALL EB.READLIST(SEL.CMD, ID.LIST, "", ID.CNT, ERR.SEL)

    ID.CTR = 1
    LOOP
    WHILE ID.CTR LE ID.CNT
        R.REC = ''; RD.ERR = ''; REC.ID = ''
        REC.ID = ID.LIST<ID.CTR>
        CALL F.READ(FN.L.APAP.TC.MIG.WORKFILE, REC.ID, R.REC, F.L.APAP.TC.MIG.WORKFILE, RD.ERR)
        IF R.REC THEN
            R.FILE.DATA<-1> = R.REC
        END
        ID.CTR += 1
    REPEAT
    WRITE R.FILE.DATA ON F.CHK.DIR, YFILE.NME ON ERROR
        CALL OCOMO("Unable to write to the file":F.CHK.DIR)
    END
    CALL EB.CLEAR.FILE(FN.L.APAP.TC.MIG.WORKFILE,F.L.APAP.TC.MIG.WORKFILE)
    RETURN

END
