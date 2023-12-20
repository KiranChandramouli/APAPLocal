* @ValidationCode : MjotMjA3ODgzMjEzNzpDcDEyNTI6MTcwMjk4ODM0NDI2MTpJVFNTMTotMTotMTowOjE6ZmFsc2U6Ti9BOlIyMl9TUDUuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 19 Dec 2023 17:49:04
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS1
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R22_SP5.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
*---------------------------------------------------------------------------------------
*MODIFICATION HISTORY:
*DATE          WHO                 REFERENCE               DESCRIPTION
*13-07-2023    CONVERSION TOOL     R22 AUTO CONVERSION     LAPAP.BP is Removed
*13-07-2023    AJITHKUMAR S        R22 MANUAL CONVERSION   NO CHANGE
*15-12-2023    Santosh C           MANUAL R22 CODE CONVERSION   APAP Code Conversion Utility Check
*----------------------------------------------------------------------------------------
SUBROUTINE L.APAP.AA.TC.MIG.DREPORT.POST

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.DATES
    $INSERT I_L.APAP.AA.TC.MIG.DREPORT.COMMON ;*R22 Auto code conversion
    $USING EB.Service ;*R22 Manual Code Conversion_Utility Check
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
*   CALL EB.CLEAR.FILE(FN.L.APAP.TC.MIG.WORKFILE,F.L.APAP.TC.MIG.WORKFILE)
    EB.Service.ClearFile(FN.L.APAP.TC.MIG.WORKFILE,F.L.APAP.TC.MIG.WORKFILE);*R22 Manual Code Conversion_Utility Check
RETURN

END
