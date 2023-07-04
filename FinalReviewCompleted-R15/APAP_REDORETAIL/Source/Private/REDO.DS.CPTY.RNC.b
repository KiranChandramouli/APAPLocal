* @ValidationCode : MjotNjA0MjI2NDI0OkNwMTI1MjoxNjgxODI5MDkzODc4OklUU1M6LTE6LTE6MTcxOjE6ZmFsc2U6Ti9BOkRFVl8yMDIxMDguMDotMTotMQ==
* @ValidationInfo : Timestamp         : 18 Apr 2023 20:14:53
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 171
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDORETAIL
SUBROUTINE REDO.DS.CPTY.RNC(Y.RET)
***********************************************************************
* COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* DEVELOPED BY: Arulprakasam P
* PROGRAM NAME: REDO.DS.CPTY.RNC
* ODR NO      : ODR-2010-07-0082
*----------------------------------------------------------------------
*DESCRIPTION: This routine is attched in DEAL.SLIP.FORMAT 'REDO.BUS.SELL'
* to get the details of the Product selected for LETTER

*IN PARAMETER:  NA
*OUT PARAMETER: NA
*LINKED WITH:
*----------------------------------------------------------------------
* Modification History :
*-----------------------
*DATE           WHO           REFERENCE         DESCRIPTION
*14-May-2011    Pradeep S     PACS00062654      Broker Type validations changed
*29-Jun-2011    Pradeep S     PACS00062662      RNC not displayed for Broker
* Modification History:
* Date                 Who                              Reference                            DESCRIPTION
*13-04-2023           CONVERSION TOOL                AUTO R22 CODE CONVERSION                 FM TO @FM, VM TO @VM
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

    LOC.REF.APPLICATION = 'CUSTOMER':@FM:'SEC.TRADE'
    LOC.REF.FIELDS = 'L.CU.RNC':@FM:'L.ST.CPTY':@VM:'L.ST.CPTY.TRDR'

    FIELD.POS = ''
    CALL MULTI.GET.LOC.REF(LOC.REF.APPLICATION,LOC.REF.FIELDS,FIELD.POS)
    POS.RNC = FIELD.POS<1,1>
    POS.CPTY = FIELD.POS<2,1>
    POS.CPTY.NAME = FIELD.POS<2,2>

RETURN

OPENFILES:
**********
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)
RETURN

PROCESS:
********


    BROKER.TYPE = R.NEW(SC.SBS.BROKER.TYPE)
    Y.RET  = ''
*PACS00062654 - S
    BEGIN CASE
        CASE BROKER.TYPE EQ 'COUNTERPARTY'
            Y.CUS.ID  = R.NEW(SC.SBS.BROKER.NO)
            GOSUB GET.RNC.VALUE
            Y.RET = Y.CU.RNC
        CASE BROKER.TYPE NE 'COUNTERPARTY'
            Y.CUS.ID = R.NEW(SC.SBS.LOCAL.REF)<1,POS.CPTY>
            IF Y.CUS.ID THEN
*Y.CUS.ID  = R.NEW(SC.SBS.BROKER.NO) ;*PACS00062662 - S/E
                GOSUB GET.RNC.VALUE
                Y.RET = Y.CU.RNC
            END
    END CASE
*PACS00062654 - E

RETURN

GET.RNC.VALUE:
**************
*PACS00062654 - New validation

    CALL F.READ(FN.CUSTOMER,Y.CUS.ID,R.CUSTOMER,F.CUSTOMER,CUSTOMER.ERR)
    Y.CU.RNC = R.CUSTOMER<EB.CUS.LOCAL.REF,POS.RNC>

RETURN
END
