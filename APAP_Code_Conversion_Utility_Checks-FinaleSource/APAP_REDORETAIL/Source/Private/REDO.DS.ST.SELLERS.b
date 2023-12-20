* @ValidationCode : MjoxMTY4NTQ0NTM1OkNwMTI1MjoxNjgxOTA1NjgxNTEzOklUU1M6LTE6LTE6MTgyOjE6ZmFsc2U6Ti9BOkRFVl8yMDIxMDguMDotMTotMQ==
* @ValidationInfo : Timestamp         : 19 Apr 2023 17:31:21
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 182
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDORETAIL
SUBROUTINE REDO.DS.ST.SELLERS(Y.RET)
***********************************************************************
* COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* DEVELOPED BY: Arulprakasam P
* PROGRAM NAME: REDO.DS.ST.SELLERS
* ODR NO      : ODR-2010-07-0082
*----------------------------------------------------------------------
*DESCRIPTION: This routine is attched in DEAL.SLIP.FORMAT 'REDO.BUS.SELL'
* to get the details of the Product selected for LETTER

*IN PARAMETER:  NA
*OUT PARAMETER: NA
*LINKED WITH:
*----------------------------------------------------------------------
* Modification History:
* Date                 Who                              Reference                            DESCRIPTION
*13-04-2023            CONVERSION TOOL                AUTO R22 CODE CONVERSION           VM TO @VM ,FM TO @FM SM TO @SM
*13-04-2023          jayasurya H                       MANUAL R22 CODE CONVERSION            NO CHANGES

*----------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.SEC.TRADE
    $INSERT I_F.CUSTOMER

    GOSUB INIT
    GOSUB OPENFILES
    GOSUB PROCESS
RETURN

INIT:
*****

    FN.CUSTOMER = 'F.CUSTOMER'
    F.CUSTOMER = ''

RETURN

OPENFILES:
**********
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)
RETURN

PROCESS:
********
    NAME.1 = ''
    SEC.TRADE.ID = Y.RET
    CUST.TRANS.CODE = R.NEW(SC.SBS.CUST.TRANS.CODE)
    CHANGE @VM TO '*' IN CUST.TRANS.CODE
    Y.COUNT.TRANS = DCOUNT(CUST.TRANS.CODE,'*')
    INIT = 1
    Y.FIRST.TRANS = FIELD(CUST.TRANS.CODE,'*',INIT)
    IF Y.FIRST.TRANS EQ 'BUY' THEN
        CUSTOMER.NO = R.NEW(SC.SBS.BROKER.NO)<1,INIT>
        CALL F.READ(FN.CUSTOMER,CUSTOMER.NO,R.CUSTOMER,F.CUSTOMER,CUSTOMER.ERR)
        SHORT.NAME = R.CUSTOMER<EB.CUS.SHORT.NAME>
        Y.INT.CNT=DCOUNT(SHORT.NAME,@VM)

        IF Y.INT.CNT GT 1 THEN
            SHORT.NAME = R.CUSTOMER<EB.CUS.SHORT.NAME,LNGG>
        END
        IF  SHORT.NAME EQ '' THEN
            SHORT.NAME = R.CUSTOMER<EB.CUS.SHORT.NAME,2>
        END

        NAME.1<-1> := SHORT.NAME
    END
    IF Y.FIRST.TRANS EQ 'SEL' THEN
        NAME.1 = ''
        NAME.1 = "APAP"
    END

    CHANGE @FM TO ',' IN NAME.1
    Y.RET = NAME.1
RETURN
END
