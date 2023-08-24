* @ValidationCode : MjotMTk3NTI1NjI1OTpDcDEyNTI6MTY4MjQxMjM2NTkwMDpIYXJpc2h2aWtyYW1DOi0xOi0xOjA6MTpmYWxzZTpOL0E6REVWXzIwMjEwOC4wOi0xOi0x
* @ValidationInfo : Timestamp         : 25 Apr 2023 14:16:05
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : HarishvikramC
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOVER
SUBROUTINE REDO.V.VAL.TYPE.OF.CARD
*--------------------------------------------------------------------------------------------------------
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.CARD.REQUEST
*--------------------------------------------------------------------------------------------------------
*Description  : This is a validation routine to validate additional card type
*Linked With  : Application REDO.CARD.REQUEST
*In Parameter : N/A
*Out Parameter: N/A
*--------------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
*    Date            Who                  Reference               Description
*   ------         ------               -------------            -------------
* 22 JUN 2011     KAVITHA               PACS00063138             ADDED PROSPECT DETAILS
*--------------------------------------------------------------------------------------------------------
*Modification History
*DATE                       WHO                         REFERENCE                                   DESCRIPTION
*17-04-2023            Conversion Tool             R22 Auto Code conversion                      FM TO @FM VM TO @VM,++ TO +=1
*17-04-2023              Samaran T                R22 Manual Code conversion                         No Changes
*-------------------------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.CARD.REQUEST
    $INSERT I_F.REDO.CARD.SERIES.PARAM
    $INSERT I_F.CUSTOMER
    $INSERT I_F.REDO.CARD.BIN
    $INSERT I_F.REDO.CARD.RENEWAL
    $INSERT I_F.LATAM.CARD.ORDER

*--------------------------------------------------------------------------------------------------------
**********
MAIN.PARA:
**********

    GOSUB OPEN.PARA
    GOSUB PROCESS.PARA

RETURN
*--------------------------------------------------------------------------------------------------------
**********
OPEN.PARA:
**********
* In this para of code file variables are initialised and opened

    FN.L.CU.CIDENT = 'F.CUSTOMER.L.CU.CIDENT'
    F.L.CU.CIDENT = ''
    CALL OPF(FN.L.CU.CIDENT,F.L.CU.CIDENT)

    FN.L.CU.NOUNICO = 'F.CUSTOMER.L.CU.NOUNICO'
    F.L.CU.NOUNICO = ''
    CALL OPF(FN.L.CU.NOUNICO,F.L.CU.NOUNICO)

    FN.L.CU.RNC = 'F.CUSTOMER.L.CU.RNC'
    F.L.CU.RNC = ''
    CALL OPF(FN.L.CU.RNC,F.L.CU.RNC)

    FN.CUSTOMER = 'F.CUSTOMER'
    F.CUSTOMER = ''
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)

    FN.REDO.CARD.BIN = 'F.REDO.CARD.BIN'
    F.REDO.CARD.BIN = ''
    CALL OPF(FN.REDO.CARD.BIN,F.REDO.CARD.BIN)


    FN.LATAM.CARD.ORDER = 'F.LATAM.CARD.ORDER'
    F.LATAM.CARD.ORDER = ''
    CALL OPF(FN.LATAM.CARD.ORDER,F.LATAM.CARD.ORDER)

    FN.CARD.RENEW = 'F.REDO.CARD.RENEWAL'
    F.CARD.RENEW = ''
    CALL OPF(FN.CARD.RENEW,F.CARD.RENEW)

    Y.PRIMARY = ''
    Y.CARD.ORDER.ID = ''
    PRINCIPAL.AVAIL = ''
    AVALI.TOT.COUNTER = ''

RETURN
*--------------------------------------------------------------------------------------------------------
*************
PROCESS.PARA:
*************
* Main processing section



    R.CUSTOMER = ''
    PROSPECT.ID = R.NEW(REDO.CARD.REQ.PROSPECT.ID)
    PRIMARY.NO =  R.NEW(REDO.CARD.REQ.PRIMARY.CARD)<1,1>
    TYPE.OF.CARD = R.NEW(REDO.CARD.REQ.TYPE.OF.CARD)<1,1>

    GOSUB GET.REDO.CARD.RENEW

    IF TYPE.OF.CARD THEN

        IF TYPE.OF.CARD EQ "PRINCIPAL" THEN

            GOSUB PRIMARY.CARD.VALIDATE

            IF PROSPECT.ID THEN
                AF = REDO.CARD.REQ.PROSPECT.ID
                AV =1
                ETEXT = "EB-PRINCIPAL.NOT.ALLOW"
                CALL STORE.END.ERROR
            END

        END ELSE
            GOSUB ADDITIONAL.TYPE.CHECK
        END
    END


*PACS00126010-S


    IF TYPE.OF.CARD EQ "ADICIONAL" THEN

        LOOP.CHK.CNTR = 1
        LOOP
        WHILE LOOP.CHK.CNTR LE AVALI.TOT.COUNTER

            CHANGE @VM TO @FM IN GET.CARD.NUMB.PREV
            CHANGE @VM TO @FM IN GET.CARD.NO.STATUS

            GOSUB LOCATE.VALUES
            LOOP.CHK.CNTR += 1

        REPEAT

        IF PRINCIPAL.AVAIL NE 'Y' THEN
            AF= REDO.CARD.REQ.TYPE.OF.CARD
            ETEXT='EB-NO.PRINC.CARD'
            CALL STORE.END.ERROR
        END

    END

RETURN
*PACS00126010-E

*--------------------------------------------------------------------------------------------------------
ADDITIONAL.TYPE.CHECK:

    IF PROSPECT.ID EQ '' THEN
        AF = REDO.CARD.REQ.PROSPECT.ID
        AV =1
        ETEXT = "EB-ADDITIONAL.MAND"
        CALL STORE.END.ERROR
    END

RETURN
*-------------
GET.REDO.CARD.RENEW:

*PACS00072694-S

    Y.CUSTOMER.ID =  R.NEW(REDO.CARD.REQ.CUSTOMER.NO)<1,1>

    Y.ACCOUNT.ID = R.NEW(REDO.CARD.REQ.ACCOUNT.NO)<1,1>
    CARD.RENW.ID = Y.CUSTOMER.ID:"-":Y.ACCOUNT.ID

    R.CARD.RENEW = ''
    CALL F.READ(FN.CARD.RENEW,CARD.RENW.ID,R.CARD.RENEW,F.CARD.RENEW,REN.ERR)
    IF R.CARD.RENEW THEN

        RENEW.TYPE.OF.CARD = R.CARD.RENEW<REDO.RENEW.TYPE.OF.CARD>
        CHANGE @VM TO @FM IN RENEW.TYPE.OF.CARD
        AVALI.TOT.COUNTER = DCOUNT(RENEW.TYPE.OF.CARD,@FM)
        GET.CARD.NUMB.PREV = R.CARD.RENEW<REDO.RENEW.PREV.CARD.NO>
        GET.CARD.NO.STATUS = R.CARD.RENEW<REDO.RENEW.STATUS>

    END

RETURN

*----------------------
PRIMARY.CARD.VALIDATE:


    LOOP.CNTR = 1

    LOOP
    WHILE LOOP.CNTR LE AVALI.TOT.COUNTER

        GET.CURRENT.TYPE = RENEW.TYPE.OF.CARD<LOOP.CNTR>
        RENEW.STATUS = R.CARD.RENEW<REDO.RENEW.STATUS,LOOP.CNTR>

        IF GET.CURRENT.TYPE EQ 'PRINCIPAL' THEN
            IF RENEW.STATUS EQ 50 OR RENEW.STATUS EQ 94  OR RENEW.STATUS EQ 90 OR RENEW.STATUS EQ 74 OR RENEW.STATUS EQ 70 OR RENEW.STATUS EQ 75 THEN
                AF = REDO.CARD.REQ.TYPE.OF.CARD
                ETEXT = "EB-PRINCIPAL.ERROR"
                CALL STORE.END.ERROR
                RETURN
            END
        END
        LOOP.CNTR += 1
    REPEAT

*PACS00072694-E

RETURN
*-----------------
LOCATE.VALUES:


    LOCATE "PRINCIPAL" IN RENEW.TYPE.OF.CARD SETTING POS THEN

        CARD.NUMB.PREV = GET.CARD.NUMB.PREV<POS>
        CARD.NO.STATUS = GET.CARD.NO.STATUS<POS>

        IF CARD.NO.STATUS EQ 94 OR CARD.NO.STATUS EQ 90 THEN
            R.NEW(REDO.CARD.REQ.PRIMARY.CARD)<1,1> = CARD.NUMB.PREV
            PRINCIPAL.AVAIL = "Y"
            GOSUB END.PGM
        END ELSE
            DEL RENEW.TYPE.OF.CARD<POS>
            DEL GET.CARD.NUMB.PREV<POS>
            DEL GET.CARD.NO.STATUS<POS>
        END

    END

RETURN
*---------------
END.PGM:

END
