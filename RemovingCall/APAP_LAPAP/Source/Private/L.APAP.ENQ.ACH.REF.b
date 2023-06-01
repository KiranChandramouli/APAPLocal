* @ValidationCode : MjotMTUxMzkyNzU3MTpDcDEyNTI6MTY4MjMzMTMyMTUzODpJVFNTOi0xOi0xOjQ4NjoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 24 Apr 2023 15:45:21
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 486
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
SUBROUTINE L.APAP.ENQ.ACH.REF (Y.ARREGLO)
*-----------------------------------------------------------------------------
*MODIFICATION HISTORY:
*
* DATE              WHO                REFERENCE                 DESCRIPTION
* 21-APR-2023     Conversion tool    R22 Auto conversion       BP Removed in insert file
* 21-APR-2023      Harishvikram C   Manual R22 conversion      No changes
*-----------------------------------------------------------------------------
    $INSERT I_COMMON ;*R22 Auto conversion - START
    $INSERT I_EQUATE
    $INSERT I_F.CUSTOMER
    $INSERT I_F.ACCOUNT
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.REDO.ACH.PROCESS.DET ;*R22 Auto conversion - END


    GOSUB INT
    GOSUB PROCESS
RETURN

INT:
    LOCATE "EXEC.ID" IN D.FIELDS<1> SETTING PRO.POS THEN
        Y.ID = D.RANGE.AND.VALUE<PRO.POS>
    END
    FN.REDO.ACH.PROCESS.DET = 'F.REDO.ACH.PROCESS.DET'
    FV.REDO.ACH.PROCESS.DET = ''
    CALL OPF (FN.REDO.ACH.PROCESS.DET,FV.REDO.ACH.PROCESS.DET )

    FN.ACH.FT.REVE.TXN = 'F.ACH.FT.REVE.TXN'
    F.ACH.FT.REVE.TXN  = ''
    CALL OPF(FN.ACH.FT.REVE.TXN,F.ACH.FT.REVE.TXN)

    FN.CHK.DIR = "&SAVEDLISTS&"; F.CHK.DIR = "" ;
    CALL OPF(FN.CHK.DIR,F.CHK.DIR)

RETURN


PROCESS:
    Y.DUPLIDOS.ID = '';
    NO.OF.REC = ''; SEL.ERR = ''; Y.COUNT.CUST = ''; CUS.POS = '';
    SEL.CMD = "SELECT ":FN.REDO.ACH.PROCESS.DET:" WITH EXEC.ID EQ " :Y.ID
    CALL EB.READLIST(SEL.CMD, SEL.LIST, "", NO.OF.REC, SEL.ERR);


    LOOP
        REMOVE Y.ID.ACH FROM SEL.LIST SETTING DET.POST
    WHILE Y.ID.ACH : DET.POST
**--------------Si no esta vacio entoces verificamos duplicados
        IF Y.DUPLIDOS.ID NE '' THEN
            LOCATE Y.ID.ACH IN Y.DUPLIDOS.ID<1> SETTING TXNCE.POS THEN
                CONTINUE
            END
        END
*---------------------------------------------------------------


        CALL F.READ (FN.REDO.ACH.PROCESS.DET,Y.ID.ACH,R.REDO.ACH.PROCESS.DET,FV.REDO.ACH.PROCESS.DET,ERROR.DET)

        Y.TXN.IDT24 = R.REDO.ACH.PROCESS.DET<REDO.ACH.PROCESS.DET.T24.TXN.ID>
        CALL F.READ(FN.ACH.FT.REVE.TXN,R.REDO.ACH.PROCESS.DET<REDO.ACH.PROCESS.DET.T24.TXN.ID>,R.ACH.FT.REVE.TXN,F.ACH.FT.REVE.TXN,ACH.FT.REVE.TXN.ERR)
        IF R.ACH.FT.REVE.TXN THEN
            Y.TXN.IDT24 = R.ACH.FT.REVE.TXN
        END

        Y.TXN.CODE = R.REDO.ACH.PROCESS.DET<REDO.ACH.PROCESS.DET.TXN.CODE>
        Y.TXN.AMOUNT = R.REDO.ACH.PROCESS.DET<REDO.ACH.PROCESS.DET.TXN.AMOUNT>
        Y.ACCOUNT = R.REDO.ACH.PROCESS.DET<REDO.ACH.PROCESS.DET.ACCOUNT>
        Y.TXN.ID = R.REDO.ACH.PROCESS.DET<REDO.ACH.PROCESS.DET.TXN.ID>
        Y.ORIGINATOR.NAME = R.REDO.ACH.PROCESS.DET<REDO.ACH.PROCESS.DET.ORIGINATOR.NAME>
        Y.STATUS = R.REDO.ACH.PROCESS.DET<REDO.ACH.PROCESS.DET.STATUS>
        Y.REJECT.CODE = R.REDO.ACH.PROCESS.DET<REDO.ACH.PROCESS.DET.REJECT.CODE>

        Y.ARREGLO<-1> = Y.ID.ACH: "|" :Y.TXN.CODE: "|" :Y.TXN.AMOUNT: "|" :Y.ACCOUNT: "|" :Y.TXN.ID: "|" :Y.ORIGINATOR.NAME: "|" :Y.STATUS:"|" :Y.REJECT.CODE: "|":Y.TXN.IDT24
*-------------Agregamos el ID para verificar si esta duplicado
        Y.DUPLIDOS.ID<-1> = Y.ID.ACH
*--------------------------------------------------------------

    REPEAT
RETURN

END
