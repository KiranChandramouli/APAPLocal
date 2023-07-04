* @ValidationCode : MjotNDM4NTAyNzEzOkNwMTI1MjoxNjgxODI5MDkzODMyOklUU1M6LTE6LTE6MTczOjE6ZmFsc2U6Ti9BOkRFVl8yMDIxMDguMDotMTotMQ==
* @ValidationInfo : Timestamp         : 18 Apr 2023 20:14:53
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 173
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDORETAIL
SUBROUTINE REDO.DS.CPTY.NAME(Y.RET)
***********************************************************************
* COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* DEVELOPED BY: Pradeep S
* PROGRAM NAME: REDO.DS.CPTY.NAME
* PACS REF    : PACS00062654
*----------------------------------------------------------------------
*DESCRIPTION: This routine is attched in DEAL.SLIP.FORMAT 'REDO.BUS.SELL'
* to get the details of the Counterparty Name

*IN PARAMETER:  NA
*OUT PARAMETER: NA
*LINKED WITH:
*----------------------------------------------------------------------
* Modification History :
*-----------------------
*DATE           WHO           REFERENCE         DESCRIPTION
*14-May-2011    Pradeep S     PACS00062654      Initial Creation
* Modification History:
* Date                 Who                              Reference                            DESCRIPTION
*13-04-2023           CONVERSION TOOL                AUTO R22 CODE CONVERSION                 VM TO @VM , FM TO @FM
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
    Y.RET = ''

    BEGIN CASE
        CASE BROKER.TYPE EQ 'COUNTERPARTY'
            Y.CUS.ID  = R.NEW(SC.SBS.BROKER.NO)
            GOSUB GET.CUS.NAME
            Y.RET = Y.CUS.NAME
        CASE BROKER.TYPE NE 'COUNTERPARTY'
            Y.CUS.ID = R.NEW(SC.SBS.LOCAL.REF)<1,POS.CPTY>

*IF NOT(Y.CUS.ID) THEN
*Y.CUS.ID  = R.NEW(SC.SBS.BROKER.NO)
*END
            GOSUB GET.CUS.NAME
            Y.RET = Y.CUS.NAME
    END CASE

RETURN

GET.CUS.NAME:
**************

    CALL F.READ(FN.CUSTOMER,Y.CUS.ID,R.CUSTOMER,F.CUSTOMER,CUSTOMER.ERR)
    Y.CUS.NAME = R.CUSTOMER<EB.CUS.SHORT.NAME>
RETURN
END
