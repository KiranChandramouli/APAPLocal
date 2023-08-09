* @ValidationCode : Mjo4MTk3NDE3NTI6Q3AxMjUyOjE2OTAxNjc5MDA0MDc6SVRTUzE6LTE6LTE6MDoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 24 Jul 2023 08:35:00
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS1
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
*-----------------------------------------------------------------------------
* <Rating>170</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE L.APAP.UPD.BEN.OACT.RT(Y.BEN)
*-----------------------------------------------------------------------------
*MODIFICATION HISTORY:
*
* DATE              WHO                REFERENCE                 DESCRIPTION
* 13-07-2023     Conversion tool    R22 Auto conversion       BP Removed
* 13-07-2023     Harishvikram C   Manual R22 conversion       No changes
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.BENEFICIARY
    $INSERT I_F.CUSTOMER
    $INSERT I_L.APAP.UPD.BEN.OACT.RT.COMMON

    GOSUB READ.BENEFICIARY
    GOSUB READ.CUSTOMER
    GOSUB PROCESS

RETURN

READ.BENEFICIARY:
    CALL F.READ(FN.BEN,Y.BEN,R.BEN,F.BEN,BEN.ERR)
    Y.OWNING.CUSTOMER = R.BEN<ARC.BEN.OWNING.CUSTOMER>
    Y.BEN.CEDULA = R.BEN<ARC.BEN.LOCAL.REF,L.BEN.CEDULA.POS>
    Y.OWN.ACCT = R.BEN<ARC.BEN.LOCAL.REF,L.BEN.OWN.ACCT.POS>
    T.MSG1 = Y.BEN : "|" : Y.OWNING.CUSTOMER : "|" : Y.BEN.CEDULA
*CALL OCOMO(T.MSG1)
RETURN

READ.CUSTOMER:
    CALL F.READ(FN.CUS,Y.OWNING.CUSTOMER,R.CUS,F.CUS,CUS.ERR)
    Y.CUS.IDENT = ''
    IF R.CUS NE '' THEN
        Y.CIDENT = R.CUS<EB.CUS.LOCAL.REF,L.CU.CIDENT.POS>
        Y.RNC = R.CUS<EB.CUS.LOCAL.REF,L.CU.RNC.POS>
        Y.NOUNICO = R.CUS<EB.CUS.LOCAL.REF,L.CU.NOUNICO.POS>

        IF Y.CIDENT NE '' THEN
            Y.CUS.IDENT = Y.CIDENT
        END ELSE
            BEGIN CASE
                CASE Y.CIDENT NE ''
                    Y.CUS.IDENT = Y.CIDENT
                CASE Y.RNC NE ''
                    Y.CUS.IDENT = Y.RNC
                CASE Y.NOUNICO NE ''
                    Y.CUS.IDENT = Y.NOUNICO
                CASE 1
                    Y.CUS.IDENT = ''
            END CASE
            CALL OCOMO("CEDULA":Y.CUS.IDENT)
        END
        T.MSG2 = "CUS:" : R.CUS<1>
*CALL OCOMO(T.MSG2)
        RETURN

PROCESS:
        IF Y.OWN.ACCT NE 'YES' THEN
*CALL OCOMO("ENTRO AL YES...")
            Y.RAW.IDENT = CHANGE(Y.BEN.CEDULA, '-', '')
            IF Y.RAW.IDENT EQ Y.CUS.IDENT THEN
*CALL OCOMO("Entro al segundo YES")
                GOSUB SEND.OFS
            END
        END
        RETURN

SEND.OFS:
        Y.TRANS.ID = ""
        Y.APP.NAME = "BENEFICIARY"
        Y.VER.NAME = Y.APP.NAME :",LAPAP.RAD"
        Y.FUNC = "I"
        Y.PRO.VAL = "PROCESS"
        Y.GTS.CONTROL = ""
        Y.NO.OF.AUTH = "0"
        FINAL.OFS = ""
        OPTIONS = ""
        Y.TRANS.ID = Y.BEN
        R.BEN<ARC.BEN.LOCAL.REF,L.BEN.OWN.ACCT.POS> = 'YES'

        CALL OFS.BUILD.RECORD(Y.APP.NAME,Y.FUNC,Y.PRO.VAL,Y.VER.NAME,Y.GTS.CONTROL,Y.NO.OF.AUTH,Y.TRANS.ID,R.BEN,FINAL.OFS)
        CALL OFS.POST.MESSAGE(FINAL.OFS,'',"BEN.OFS.INPUT",'')
        RETURN

    END
