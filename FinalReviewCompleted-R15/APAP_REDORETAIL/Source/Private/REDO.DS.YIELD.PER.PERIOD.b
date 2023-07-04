* @ValidationCode : MjoyMDAwOTg1ODQ4OkNwMTI1MjoxNjgxOTA1NjgxNjM1OklUU1M6LTE6LTE6MTgxOjE6ZmFsc2U6Ti9BOkRFVl8yMDIxMDguMDotMTotMQ==
* @ValidationInfo : Timestamp         : 19 Apr 2023 17:31:21
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 181
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDORETAIL
SUBROUTINE REDO.DS.YIELD.PER.PERIOD(IN.OUT.PARA)
*------------------------------------------------------------------------------------------------------------
* DESCRIPTION : This deal slip routine should be attached to the DEAL.SLIP.FORMAT, REDO.BUY.SELL.DSLIP
*------------------------------------------------------------------------------------------------------------
* * Input / Output
* --------------
* IN Parameter    : NA
* OUT Parameter   : NA
*--------------------------------------------------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : NAVEENKUMAR N
* PROGRAM NAME : REDO.DS.YIELD.PER.PERIOD
*--------------------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
* Date             Author             Reference                   Description
* 11-Aug-2010      Naveenkumar N     ODR-2010-07-0082            Initial creation
* 28-Apr-2011      Pradeep S         PACS00056285                Mapping changed
* Modification History:
* Date                 Who                              Reference                            DESCRIPTION
*13-04-2023           CONVERSION TOOL                AUTO R22 CODE CONVERSION                 NO CHANGES
*13-04-2023          jayasurya H                       MANUAL R22 CODE CONVERSION            NO CHANGES

*----------------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.SEC.TRADE
    $INSERT I_F.SECURITY.MASTER
*

    GOSUB INIT
    GOSUB PROCESS
RETURN
*****
INIT:
*****
* Initialising necessay variables
*
    FN.SECURITY.MASTER = "F.SECURITY.MASTER"
    F.SECURITY.MASTER = ""
    R.SECURITY.MASTER = ""
    E.SECURITY.MASTER = ""
    CALL OPF(FN.SECURITY.MASTER,F.SECURITY.MASTER)

    LOC.REF.APPLICATION = 'SEC.TRADE'
    LOC.REF.FIELDS = 'L.SC.TRN.YIELD'

    FIELD.POS = ''
    CALL MULTI.GET.LOC.REF(LOC.REF.APPLICATION,LOC.REF.FIELDS,FIELD.POS)
    POS.TRN.YIELD = FIELD.POS<1,1>

RETURN

********
PROCESS:
********
* Process to find y.result
*PACS00056285 - Mapping changed to calculate yield for the period

    Y.ID = IN.OUT.PARA
    IN.OUT.PARA = ''
    Y.SECURITY.CODE = R.NEW(SC.SBS.SECURITY.CODE)
    CALL F.READ(FN.SECURITY.MASTER,Y.SECURITY.CODE,R.SECURITY.MASTER,F.SECURITY.MASTER,E.SECURITY.MASTER)
    Y.NO.OF.PAYMENTS = R.SECURITY.MASTER<SC.SCM.NO.OF.PAYMENTS>
*
    Y.TRN.YIELD = R.NEW(SC.SBS.LOCAL.REF)<1,POS.TRN.YIELD>
    IF Y.TRN.YIELD NE '' THEN
        Y.FIN.RES = (Y.TRN.YIELD/Y.NO.OF.PAYMENTS)
        IN.OUT.PARA = Y.FIN.RES
    END
RETURN
END
