$PACKAGE APAP.LAPAP
* @ValidationCode : Mjo1NzcwNjU5Mjg6Q3AxMjUyOjE2ODkyMzYxNzk4Njc6MzMzc3U6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 13 Jul 2023 13:46:19
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : 333su
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.

*---------------------------------------------------------------------------------------
*Modification History:
*DATE                 WHO                    REFERENCE                     DESCRIPTION
*13/07/2023      Conversion tool            R22 Auto Conversion           BP removed in INSERT file
*13/07/2023      Suresh                     R22 Manual Conversion           Nochange
*----------------------------------------------------------------------------------------
SUBROUTINE LAPAP.REV.ABONO.CHARG

    $INSERT I_COMMON ;*R22 Auto Conversion - Start
    $INSERT I_EQUATE
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.L.APAP.GENERACION.CARGO
    $INSERT I_F.L.APAP.LIMITE.ABONADO ;*R22 Auto Conversion - End

    GOSUB LOAD
    GOSUB PROCESS

*****
LOAD:
*****
    Y.FT.ID = ID.NEW.LAST

    FN.ST.L.APAP.GENERACION.CARGO = "F.ST.L.APAP.GENERACION.CARGO"
    FV.ST.L.APAP.GENERACION.CARGO = ""
    CALL OPF (FN.ST.L.APAP.GENERACION.CARGO,FV.ST.L.APAP.GENERACION.CARGO)

    FN.ST.L.APAP.LIMITE.ABONADO = "F.ST.L.APAP.LIMITE.ABONADO"
    F.ST.L.APAP.LIMITE.ABONADO = ""
    CALL OPF (FN.ST.L.APAP.LIMITE.ABONADO,F.ST.L.APAP.LIMITE.ABONADO)

    FN.FUNDS.TRANSFER = "F.FUNDS.TRANSFER"
    FV.FUNDS.TRANSFER = ""
    CALL OPF (FN.FUNDS.TRANSFER,FV.FUNDS.TRANSFER)

RETURN

********
PROCESS:
********
    SEL.CMD = ''; SEL.LIST = ''; NO.OF.REC = ''; SEL.ERR = ''
    SEL.CMD = " SELECT " : FN.ST.L.APAP.LIMITE.ABONADO: " WITH TRANSACTION EQ ":Y.FT.ID
    CALL EB.READLIST(SEL.CMD, SEL.LIST, "", NO.OF.REC, SEL.ERR)

    Y.CHARGE.ID = SEL.LIST
    R.CHARGE = ""; ERR.CHARGE = " "
    CALL F.READ (FN.ST.L.APAP.LIMITE.ABONADO,Y.CHARGE.ID,R.CHARGE,F.ST.L.APAP.LIMITE.ABONADO,ERR.CHARGE)
    Y.TRANSACTION.ID = R.CHARGE<ST.L.A61.TRANSACTION>

    IF Y.TRANSACTION.ID EQ Y.FT.ID THEN

        Y.APP.NAME                          = 'ST.L.APAP.LIMITE.ABONADO';
        Y.VER.NAME                          = Y.APP.NAME:',REVERS';
        Y.FUNC                              = 'R';
        Y.PRO.VAL                           = "PROCESS";
        Y.GTS.CONTROL                       = "";
        Y.NO.OF.AUTH                        = "";
        FINAL.OFS                           = "";
        Y.TRANS.ID                          = Y.CHARGE.ID;

        CALL OFS.BUILD.RECORD(Y.APP.NAME,Y.FUNC,Y.PRO.VAL,Y.VER.NAME,Y.GTS.CONTROL,Y.NO.OF.AUTH,Y.TRANS.ID,R.CHARGE,FINAL.OFS)
        OFS.MSG.ID = ''; OFS.SOURCE.ID = "OFS.CARGO"; OPTIONS = ''
        CALL OFS.POST.MESSAGE(FINAL.OFS,OFS.MSG.ID,OFS.SOURCE.ID,OPTIONS)
    END
RETURN
END
