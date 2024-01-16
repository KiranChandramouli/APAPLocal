* @ValidationCode : MjoyMDA1NTMwNDI1OkNwMTI1MjoxNjg0MjMzNTM3ODc0OklUU1M6LTE6LTE6MjQ3MjoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 16 May 2023 16:08:57
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 2472
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
SUBROUTINE PRO.RPT.MILLAS.LIBERADA
*---------------------------------------------------------------------------------------------------
*Modification History
*DATE                WHO                         REFERENCE                DESCRIPTION
*24-04-2023       Conversion Tool        R22 Auto Code conversion          INSERT FILE MODIFIED,I TO I.VAR,J TO J.VAR,F.READ TO CACHE.READ,CHAR TO CHARX
*24-04-2023       Samaran T               R22 Manual Code Conversion       No Changes
*-----------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON    ;*R22 AUTO CODE CONVERSION.START
    $INSERT I_EQUATE
    $INSERT I_F.CUSTOMER
    $INSERT I_F.REDO.LY.POINTS
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.ACCOUNT
    $INSERT I_F.CATEGORY
    $INSERT I_F.AA.ARRANGEMENT.ACTIVITY
    $INSERT I_F.AA.ARRANGEMENT     ;*R22 AUTO CODE CONVERSION.END
   $USING EB.LocalReferences

*DEBUG
************************************************************
*APERTURA DE ARCHIVOS A UTILIZAR
************************************************************
    FN.LY = "F.REDO.LY.POINTS"
    FV.LY = ""
    CALL OPF(FN.LY,FV.LY)

    FN.CS = "F.CUSTOMER"
    FV.CS = ""
    CALL OPF(FN.CS,FV.CS)

    FN.FT = "F.FUNDS.TRANSFER$HIS"
    FV.FT = ""
    CALL OPF(FN.FT,FV.FT)

    FN.AC = "F.ACCOUNT"
    FV.AC = ""
    CALL OPF(FN.AC,FV.AC)

    FN.AC.H = "F.ACCOUNT$HIS"
    FV.AC.H = ""
    CALL OPF(FN.AC.H,FV.AC.H)

    FN.CT = "F.CATEGORY"
    FV.CT = ""
    CALL OPF(FN.CT,FV.CT)

    FN.AAT = "F.AA.ARRANGEMENT.ACTIVITY"
    FV.AAT = ""
    CALL OPF(FN.AAT,FV.AAT)

    FN.AA = "F.AA.ARRANGEMENT"
    FV.AA = ""
    CALL OPF(FN.AA,FV.AA)

************************************************************
*COMANDO DE SELECION - PRINCIPAL
************************************************************
    SEL.CMD = ""
    SEL.LIST = ""
    NO.OF.RECS = ""
    SEL.ERR = ""

    SEL.CMD = "SELECT F.REDO.LY.POINTS WITH PROGRAM EQ PL00002"
*SEL.CMD = "SELECT F.REDO.LY.POINTS WITH PROGRAM EQ PL00002 AND STATUS EQ Liberada AND @ID EQ 9174006 9703424 604479 2701102"
*SEL.CMD = "SELECT F.REDO.LY.POINTS WITH PROGRAM EQ PL00002 AND STATUS EQ Liberada SAMPLE 100"
*SEL.CMD = "SELECT F.REDO.LY.POINTS WITH PROGRAM EQ PL00002 AND @ID EQ 189189"
    CALL EB.READLIST(SEL.CMD, SEL.LIST, '',NO.OF.RECS,SEL.ERR)

************************************************************
*VARIABLE GLOBALES
************************************************************
    Y.FINAL = ""
    Y.LY.ID = ""
    Y.YYYYMM = ""
    Y.ENCABEZADO = "GENERATION DATE,FREQUENT FLYER NO.,TOTAL OF MILES,SECOND NAME,FIRST NAME"
    Y.ENCABEZADO = Y.ENCABEZADO : ",STATUS,CODIGO CLIENTE,OPERACION,PRESTAMO,CATEGORIA,DESC CATEGORIA"

    Y.YYYYMM = ""
*DEBUG
************************************************************
*LECTURA DE PARAMETROS
************************************************************
*    EXECUTE "GET.LIST MILLAS.YYYYMM.LIST"
* READLIST ID.LIST ELSE
*ID.LIST = ''
*STOP
*END
*LOOP
*REMOVE Y.ID FROM ID.LIST SETTING Y.STATUS
*WHILE  Y.ID:Y.STATUS
*Y.YYYYMM := Y.ID
*REPEAT

    Y.DIR.NAME1 = "../bnk.interface/T24MILLAS"
    Y.FILE.NAME1 = "MILLAS.YYYYMM.LIST"

    OPENSEQ Y.DIR.NAME1,Y.FILE.NAME1 TO FV.PRT ELSE
        PRINT @(12,12): 'NO SE PUDO ABRIR EL DIRECTORIO'
    END

    LOOP
        READSEQ Y.REC FROM FV.PRT ELSE Y.EOF = 1
        Y.YYYYMM = Y.REC
    WHILE NOT(Y.EOF)
    REPEAT
    CLOSESEQ FV.PRT


*DEBUG
************************************************************
*ARCHIVO DE SALIDA
************************************************************
    Y.DIR.NAME = "../bnk.interface/T24MILLAS"
    Y.FILE.NAME = "CERITOS.LIBERADOS." : Y.YYYYMM  : ".CSV"

    DELETESEQ Y.DIR.NAME, Y.FILE.NAME ELSE NULL

    OPENSEQ Y.DIR.NAME,Y.FILE.NAME TO FV.PTR ELSE
        CREATE FV.PTR ELSE
            CRT "NO SE PUEDE CREAR ARCHIVO: " : Y.FILE.NAME : " DEL DIRECTORIO: " : Y.DIR.NAME
            STOP
        END
    END

    WRITESEQ Y.ENCABEZADO TO FV.PTR ELSE
        CRT "NO SE PRUEDE ESCRIBIR EN EL ARCHIVO: " : Y.FILE.NAME
    END

************************************************************
*LOOP DE PROCESAMIENTO DE DATOS
************************************************************
    LOOP
        REMOVE Y.LY.ID FROM SEL.LIST SETTING FI.POS
    WHILE Y.LY.ID DO

*-----------------------------------------------------------
*CUSTOMER
*-----------------------------------------------------------
        R.CS = ""; CS.ERROR = ""
        CALL F.READ(FN.CS, Y.LY.ID, R.CS, FV.CS, CS.ERROR)
        Y.GIVEN.NAMES = R.CS<EB.CUS.GIVEN.NAMES>
        Y.FAMILY.NAME = R.CS<EB.CUS.FAMILY.NAME>
**DEBUG
*        CALL GET.LOC.REF("CUSTOMER","L.CU.NOM.AIR",CS.POS.L.CU.NOM.AIR)
EB.LocalReferences.GetLocRef("CUSTOMER","L.CU.NOM.AIR",CS.POS.L.CU.NOM.AIR);* R22 UTILITY AUTO CONVERSION
        Y.L.CU.NOM.AIR = R.CS<EB.CUS.LOCAL.REF,CS.POS.L.CU.NOM.AIR>

*        CALL GET.LOC.REF("CUSTOMER","L.CU.NO.VIA.F",CS.POS.L.CU.NO.VIA.F)
EB.LocalReferences.GetLocRef("CUSTOMER","L.CU.NO.VIA.F",CS.POS.L.CU.NO.VIA.F);* R22 UTILITY AUTO CONVERSION
        Y.L.CU.NO.VIA.F = R.CS<EB.CUS.LOCAL.REF,CS.POS.L.CU.NO.VIA.F>

*-----------------------------------------------------------
*REDO.LY.POINTS
*-----------------------------------------------------------
        R.LY = ""; LY.ERROR = ""
        CALL F.READ(FN.LY, Y.LY.ID, R.LY, FV.LY, LY.ERROR)

**DEBUG
        IF Y.L.CU.NOM.AIR EQ "AA" THEN
**DEBUG
            Y.MV.CNT = DCOUNT(R.LY<REDO.PT.PROGRAM>, @VM)
            FOR I.VAR = 1 TO Y.MV.CNT
                Y.SV.CNT = DCOUNT(R.LY<REDO.PT.PROGRAM,I.VAR>, @SM)
                FOR J.VAR = 1 TO Y.SV.CNT
                    Y.PROGRAM =  R.LY<REDO.PT.PROGRAM,I.VAR,J.VAR>
                    Y.STATUS =   R.LY<REDO.PT.STATUS,I.VAR,J.VAR>
                    Y.GEN.DATE = R.LY<REDO.PT.GEN.DATE,I.VAR,J.VAR>
                    Y.QUANTITY = R.LY<REDO.PT.QUANTITY,I.VAR,J.VAR>
                    Y.TXN.ID = R.LY<REDO.PT.TXN.ID,I.VAR,J.VAR>

*IF Y.PROGRAM EQ "PL00002" AND Y.STATUS EQ "Liberada" AND Y.GEN.DATE[1,6] EQ Y.YYYYMM  THEN
                    IF Y.PROGRAM EQ "PL00002" AND Y.GEN.DATE[1,6] EQ Y.YYYYMM  THEN
                        IF Y.TXN.ID[1,2] EQ "FT" THEN
*-----------------------------------------------------------
*FUNDS.TRANSFER
*-----------------------------------------------------------
**DEBUG
                            Y.TXN.ID.HIS = Y.TXN.ID : ";1"
                            R.FT = ""; FT.ERROR = ""
                            CALL F.READ(FN.FT, Y.TXN.ID.HIS, R.FT, FV.FT, FT.ERROR)
                            Y.TRANSACTION.TYPE = R.FT<FT.TRANSACTION.TYPE>
                            Y.CREDIT.ACCT.NO = R.FT<FT.CREDIT.ACCT.NO>
                        END
                        ELSE
*-----------------------------------------------------------
*AA.ARRANGEMENT.ACTIVITY
*-----------------------------------------------------------
                            R.AAT = ""; AAT.ERROR = ""
                            CALL F.READ(FN.AAT, Y.TXN.ID, R.AAT, FV.AAT, AAT.ERROR)
                            Y.ARRANGEMENT = R.AAT<AA.ARR.ACT.ARRANGEMENT>

*-----------------------------------------------------------
*AA.ARRANGEMENT
*-----------------------------------------------------------
                            R.AA = ""; AA.ERROR = ""
                            CALL F.READ(FN.AA, Y.ARRANGEMENT, R.AA, FV.AA, AA.ERROR)
                            Y.LINKED.APPL.ID = R.AA<AA.ARR.LINKED.APPL.ID>
                            Y.CREDIT.ACCT.NO =  Y.LINKED.APPL.ID
                        END

**DEBUG
*-----------------------------------------------------------
*ACCOUNT
*-----------------------------------------------------------
                        R.AC = ""; AC.ERROR = ""
                        CALL F.READ(FN.AC, Y.CREDIT.ACCT.NO, R.AC, FV.AC, AC.ERROR)
                        Y.CATEGORY = R.AC<AC.CATEGORY>
                        Y.ARRANGEMENT.ID = R.AC<AC.ARRANGEMENT.ID>

                        IF Y.CATEGORY EQ "" THEN
                            Y.CREDIT.ACCT.NO.HIST = Y.CREDIT.ACCT.NO : ";1"
                            R.AC.H = ""; AC.H.ERROR = ""
                            CALL F.READ(FN.AC.H, Y.CREDIT.ACCT.NO.HIST, R.AC.H, FV.AC.H, AC.H.ERROR)
                            Y.CATEGORY = R.AC.H<AC.CATEGORY>
                        END

*-----------------------------------------------------------
*CATEGORY
*-----------------------------------------------------------
                        R.CT = ""; CT.ERROR = ""
                        CALL CACHE.READ(FN.CT, Y.CATEGORY, R.CT, CT.ERROR)     ;*R22 AUTO CODE CONVERSION
                        Y.CAT.DESCRIPTION = R.CT<EB.CAT.DESCRIPTION>

*-----------------------------------------------------------
*REGISTRO A ESCRIBIR
*-----------------------------------------------------------
                        Y.IN.AAR.ID = Y.ARRANGEMENT.ID
                        Y.IN.FT.ID = Y.TXN.ID
                        Y.OU.RETORNO = ""

                        APAP.LAPAP.proRptMillasLiberadaMora(Y.IN.AAR.ID, Y.IN.FT.ID, Y.OU.RETORNO);* R22 Manual conversion

                        IF Y.OU.RETORNO EQ "NO" THEN

                            Y.FINAL = Y.GEN.DATE : ","
                            Y.FINAL = Y.FINAL : Y.L.CU.NO.VIA.F : ","
                            Y.FINAL = Y.FINAL : Y.QUANTITY : ","
                            Y.FINAL = Y.FINAL : Y.FAMILY.NAME : ","
                            Y.FINAL = Y.FINAL : Y.GIVEN.NAMES : ","
                            Y.FINAL = Y.FINAL : Y.STATUS : ","
                            Y.FINAL = Y.FINAL : Y.LY.ID : ","
                            Y.FINAL = Y.FINAL : Y.TXN.ID : ","
                            Y.FINAL = Y.FINAL : Y.CREDIT.ACCT.NO : ","
                            Y.FINAL = Y.FINAL : Y.CATEGORY : ","
                            Y.FINAL = Y.FINAL : Y.CAT.DESCRIPTION : CHARX(13)    ;*R22 AUTO CODE CONVERSION

                            WRITESEQ Y.FINAL TO FV.PTR ELSE
                                CRT "NO SE PRUEDE ESCRIBIR EN EL ARCHIVO: " : Y.FILE.NAME
                            END
                        END
                    END
                NEXT J.VAR
            NEXT I.VAR
        END
    REPEAT
    CLOSESEQ FV.PTR
END
