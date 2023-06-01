* @ValidationCode : MjoxMzQzMjM5MzE4OkNwMTI1MjoxNjg1NTM2MDQzMDM2OnZpY3RvOi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 31 May 2023 17:57:23
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : victo
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOVER
SUBROUTINE REDO.V.VAL.GET.CTENAME
*--------------------------------------------------------------------------------
*Company   Name    :Asociacion Popular de Ahorros y Prestamos
*Developed By      :NAVA V
*Program   Name    :REDO.V.VAL.GET.CTENAME
*------------------------------------------------------------------------------------
*DESCRIPTION       :This program is used to get the CARDHOLDER NAME of the Debit Card
*
*Date           ref                 who             description
*20-10-2011   PACS00142988          Nava V.
*23-08-2012   PACS00203353          GANESH.R        Added extra Validations as per the requirement.
* ----------------------------------------------------------------------------------
*Modification History
*DATE                WHO                         REFERENCE                DESCRIPTION
*17-04-2023       Conversion Tool        R22 Auto Code conversion         VM TO @VM
*17-04-2023       Samaran T               R22 Manual Code Conversion      CALL ROUTINE FORMAT MODIFIED
*---------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_F.CUSTOMER
    $INSERT I_F.TELLER
    $INSERT I_F.ALTERNATE.ACCOUNT
    $USING APAP.TAM
*
    GOSUB INIT
*----------------------------------
*PACS00203353-S
    APAP.TAM.redoChkDebitCardNumber()    ;*R22 MANUAL CODE CONVERSION
*PACS00203353-E
*----------------------------------
    GOSUB CHECK.PRELIM.CONDITIONS
*
    IF  PROCESS.GOAHEAD THEN
        GOSUB PROCESS
    END
*
RETURN
*
**************
PROCESS:
*************
* DEBIT CARD NUMBER is the ID of Alternate Account.
*
    R.ACCOUNT = "" ; ERR = ''
    CALL F.READ(FN.ACCOUNT,VAR.ACCOUNT.ID,R.ACCOUNT,F.ACCOUNT,ERR)
*
    IF R.ACCOUNT NE "" THEN
        VAR.CARDH.CUSID = ''
        VAR.CARDH.CUSID=R.ACCOUNT<AC.CUSTOMER>
        COMI = COMI[1,6]:'******':COMI[13,4]
        GOSUB GET.CUST.DETAILS
    END
*
RETURN
*
****************
GET.CUST.DETAILS:
*****************
*
    R.CUSTOMER = "" ; ERR = ''
    CALL F.READ(FN.CUSTOMER,VAR.CARDH.CUSID,R.CUSTOMER,F.CUSTOMER,ERR)
    IF R.CUSTOMER NE "" THEN
        VAR.CARDH.NAME = ''
        VAR.CARDH.NAME=R.CUSTOMER<EB.CUS.NAME.1>

        COMI = COMI[1,6]:'******':COMI[13,4]
        R.NEW(TT.TE.LOCAL.REF)<1,Y.TT.CUST.NME> = VAR.CARDH.NAME
    END
*
RETURN
*
* ----------------
CONTROL.MSG.ERROR:
* ----------------
*
*   Paragraph that control the error in the subroutine
*
    IF Y.ERR.MSG THEN
        ETEXT  = Y.ERR.MSG
        CALL STORE.END.ERROR
        ETEXT  = ""
    END
*
RETURN
*
*********
INIT:
*********

    PROCESS.GOAHEAD = 1

    FN.ALTERNATE.ACCOUNT='F.ALTERNATE.ACCOUNT'
    F.ALTERNATE.ACCOUNT=''
    CALL OPF(FN.ALTERNATE.ACCOUNT,F.ALTERNATE.ACCOUNT)

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    FN.CUSTOMER = 'F.CUSTOMER'
    F.CUSTOMER = ''
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)

    LRF.APP   = "TELLER"
    LRF.FIELD = "L.TT.CLIENT.NME":@VM:"L.TT.CR.CARD.NO"
    LRF.POS   = ''
    CALL MULTI.GET.LOC.REF(LRF.APP,LRF.FIELD,LRF.POS)

    Y.TT.CUST.NME=LRF.POS<1,1>
    Y.TT.CARD.NUM=LRF.POS<1,2>

    VAR.AA.ID          = COMI
    Y.VAR.LEN          = ""
    Y.ERR.MSG          = ""
    Y.FLD              = ""

RETURN
*
* ======================
CHECK.PRELIM.CONDITIONS:
* ======================
*
    LOOP.CNT  = 1
    MAX.LOOPS = 3
*
    LOOP
    WHILE LOOP.CNT LE MAX.LOOPS AND PROCESS.GOAHEAD DO
        BEGIN CASE
*
            CASE LOOP.CNT EQ 1

                IF MESSAGE EQ "VAL" THEN
                    PROCESS.GOAHEAD = ""
                END

            CASE LOOP.CNT EQ 2
*
                IF VAR.AA.ID EQ "" THEN
                    PROCESS.GOAHEAD = ""
                    RETURN
                END
*
                Y.VAR.LEN = LEN(VAR.AA.ID)
                IF Y.VAR.LEN NE 16 THEN
                    Y.ERR.MSG = "EB-INVALID.CARD"
                    AF = TT.TE.LOCAL.REF
                    AV = Y.TT.CARD.NUM
                END
*
            CASE LOOP.CNT EQ 3
*
                CALL F.READ(FN.ALTERNATE.ACCOUNT,VAR.AA.ID,R.ALTERNATE.ACCOUNT,F.ALTERNATE.ACCOUNT,ERR)
                VAR.ACCOUNT.ID=R.ALTERNATE.ACCOUNT<AAC.GLOBUS.ACCT.NUMBER>
                IF R.ALTERNATE.ACCOUNT EQ "" THEN
                    R.NEW(TT.TE.LOCAL.REF)<1,Y.TT.CUST.NME> = ""
                    Y.ERR.MSG = "EB-NO.CUST.CARD"
                    AF = TT.TE.LOCAL.REF
                    AV = Y.TT.CARD.NUM
                END
*
        END CASE
*       Message Error
        GOSUB CONTROL.MSG.ERROR
*       Increase
        LOOP.CNT +=1
*
    REPEAT
*
RETURN
*
END
