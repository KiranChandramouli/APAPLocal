* @ValidationCode : MjoyMTA4NDMyNzkwOkNwMTI1MjoxNzA0ODAxMTQ3MzU2OnZpZ25lc2h3YXJpOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 09 Jan 2024 17:22:27
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : vigneshwari
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP


* Item ID        : BIT007374
*-------------------------------------------------------------------------------------
* Description :
* ------------
* This program allow verify the telephone number taking some condictions
*-------------------------------------------------------------------------------------
* Modification History :
* ----------------------
* Date           Author            Modification Description
* -------------  -----------       ---------------------------
* 2017/12/11     Raquel P.S.         Initial development
*-------------------------------------------------------------------------------------
* Content summary :
* -----------------
* Versions : FUNDS.TRANSFER,L.APAP.PRESTAC.LAB
* EB record      : LAPAP.RTN.ABORT.TXN
* PGM record     : LAPAP.RTN.ABORT.TXN
* Routines       : LAPAP.RTN.ABORT.TXN
*-------------------------------------------------------------------------------------
*Modification History
*DATE                WHO                         REFERENCE                DESCRIPTION
*21-04-2023       Conversion Tool        R22 Auto Code conversion          INSERT FILE MODIFIED
*21-04-2023       Samaran T               R22 Manual Code Conversion       No Changes
*09-01-2024	  VIGNESHWARI       ADDED COMMENT FOR INTERFACE CHANGES          SQA-11970 � By Santiago
*-------------------------------------------------------------------------------------------------


SUBROUTINE LAPAP.RTN.ABORT.TXN

    $INSERT I_COMMON      ;*R22 AUTO CODE CONVERSION.START
    $INSERT I_EQUATE
    $INSERT I_F.TELLER
    $INSERT I_GTS.COMMON
    $INSERT I_F.FUNDS.TRANSFER     ;*R22 AUTO CODE CONVERSION.END

    FN.FUNDS.TRANSFER = "FBNK.FUNDS.TRANSFER"
    F.FUNDS.TRANSFER = ""

    CALL OPF(FN.FUNDS.TRANSFER,F.FUNDS.TRANSFER)
    POS.DEBIT.AMOUNT=COMI
    R.NEW(FT.DEBIT.AMOUNT)=POS.DEBIT.AMOUNT	;*Fix SQA-11970 � By Santiago-new line added

* Conseguir valor local del campo Cuenta de Credito desde la version

    POS.CREDIT.ACT.NO= R.NEW(FT.CREDIT.ACCT.NO)

    IF POS.CREDIT.ACT.NO NE '' THEN	;*Fix SQA-11970 � By Santiago-new line added
* Comando de seleccion en base a valores enviados desde el archivo de pago
    NO.OF.REC=''	;*Fix SQA-11970 � By Santiago-new line added
    SEL.CMD = "SELECT " :FN.FUNDS.TRANSFER: " WITH TRANSACTION.TYPE EQ ACN1 AND DEBIT.AMOUNT EQ " :POS.DEBIT.AMOUNT : " AND CREDIT.ACCT.NO EQ ": POS.CREDIT.ACT.NO
    CALL EB.READLIST(SEL.CMD, Y.FT.ID,"", NO.OF.REC, SEL.ERR)
    Y.VALUE=1


    IF NO.OF.REC GE Y.VALUE
    THEN
        ETEXT='OPERACION ABORTADA; TXN EXISTE CON IGUAL MONTO Y CUENTA.'
        CALL STORE.END.ERROR


***************************************************************************
*      ESCRIBIENDO ARCHIVO DE TEXTO CON LA TRANSACCION FALLIDA      *
***************************************************************************


*        Y.DIR.NAME = "../interface/FLAT.INTERFACE/TRANSPRESTALAB"
*        Y.FILE.NAME = "DETALLETxnABORTADA":DATE():".":OCONV(TIME(),"MTS")
*
*        OPENSEQ Y.DIR.NAME,Y.FILE.NAME TO FV.PTR ELSE
*            CREATE FV.PTR ELSE
*                CRT "CANNOT OPEN DIR ": Y.DIR.NAME
*                STOP
*            END
*        END

*        Y.DETAIL= "DETALLES TRANSACCION EXISTENTE: ":Y.FT.ID: "NO.OF.REC: ":Y.FT.ID: "SEL.CMD: ":SEL.CMD
*        Y.FINAL = "La transaccion de Monto; ":POS.DEBIT.AMOUNT : " y numero de contrato; ":POS.CREDIT.ACT.NO : " presenta una transaccion duplicada tipo ACN1 (" :Y.FT.ID: ") OPERACION ABORTADA!"
*        WRITESEQ Y.FINAL TO FV.PTR
*        ELSE
*            CRT "UNABLE TO WRITE TO FILE"
*        END
*
*        RETURN
    END

END	;*Fix SQA-11970 � By Santiago-new line added
END
