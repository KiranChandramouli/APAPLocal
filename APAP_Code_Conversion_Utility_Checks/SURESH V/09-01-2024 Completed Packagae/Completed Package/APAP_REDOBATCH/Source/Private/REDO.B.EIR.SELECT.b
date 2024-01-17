* @ValidationCode : MjoxMDM4MjQzOTY1OkNwMTI1MjoxNzAzNTg0NTMzMjY2OjMzM3N1Oi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 26 Dec 2023 15:25:33
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
$PACKAGE APAP.REDOBATCH
SUBROUTINE REDO.B.EIR.SELECT
*--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
* DESCRIPTION : This BATCH routine will look for the own book records from SC.TRADING.POSITION to reverse the CATEG.ENTRY and re-calculate interest accrual based on
*               effective interest rate method and raise accounting entries
*--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
* * Input / Output
* --------------
* IN Parameter    : NA
* OUT Parameter   : NA
*--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : NAVEENKUMAR N
* PROGRAM NAME : REDO.B.EIR.MTHD
*--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
* Date             Author             Reference           Description
* 23 Oct 2010      Naveen Kumar N     ODR-2010-07-0081    Initial creation
* 29 Sep 2011      Pradeeep S         PACS00133293        Code Review changes
* Date                  who                   Reference
* 11-04-2023        �CONVERSTION TOOL   �  R22 AUTO CONVERSTION - No Change
* 11-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION -NO CHANGES
*26/12/2023         Suresh                R22 Manual Conversion    IDVAR Variable Changed
*---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.SECURITY.MASTER
    $INSERT I_F.SEC.TRADE
    $INSERT I_F.SC.TRADING.POSITION
    $INSERT I_F.REDO.H.ST.SUB.ASSET.TYPE
    $INSERT I_REDO.B.EIR.COMMON
    $INSERT I_F.REDO.CALL.LIST.CATEG
    
    $USING EB.Service
*--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    IDVAR="SYSTEM" ;*R22 Manual Conversion
*    CALL CACHE.READ(FN.REDO.H.ST.SUB.ASSET.TYPE,"SYSTEM",R.REDO.H.ST.SUB.ASSET.TYPE,E.REDO.H.ST.SUB.ASSET.TYPE)
    CALL CACHE.READ(FN.REDO.H.ST.SUB.ASSET.TYPE,IDVAR,R.REDO.H.ST.SUB.ASSET.TYPE,E.REDO.H.ST.SUB.ASSET.TYPE) ;*R22 Manual Conversion

    SUB.ASSET.TYPE.TABLE.VAL         = R.REDO.H.ST.SUB.ASSET.TYPE<REDO.SAT.SUB.ASSET.TYPE>

*CALL F.READ(FN.REDO.CALL.LIST.CATEG,'SYSTEM',R.REDO.CALL.LIST.CATEG,F.REDO.CALL.LIST.CATEG,ERR.RCLC)
    IDVAR='SYSTEM' ;*R22 Manual Conversion
*    CALL CACHE.READ(FN.REDO.CALL.LIST.CATEG,'SYSTEM',R.REDO.CALL.LIST.CATEG,ERR.RCLC)       ;*PACS00133293 - S/E
    CALL CACHE.READ(FN.REDO.CALL.LIST.CATEG,IDVAR,R.REDO.CALL.LIST.CATEG,ERR.RCLC)  ;*R22 Manual Conversion
    IF R.REDO.CALL.LIST.CATEG THEN

        LOCATE 'SC002-AMRT' IN R.REDO.CALL.LIST.CATEG<CALL.LIST.CATEG.DESCRIPTION,1> SETTING POS.SC002.ACRU THEN
            Y.CATEGORY = R.REDO.CALL.LIST.CATEG<CALL.LIST.CATEG.CATEGORY,POS.SC002.ACRU>
        END

    END

    Y.CATEG.VAL           = Y.CATEGORY
    D.FIELDS              = "CATEGORY":@FM:"BOOKING.DATE"
    D.RANGE.AND.VALUE     = Y.CATEG.VAL:@FM:TODAY
    D.LOGICAL.OPERANDS    = "1":@FM:"1"
    CALL E.CATEG.ENT.BY.CONCAT(Y.ID.LIST2)
    SEL.LIST              = FIELDS(Y.ID.LIST2,'*',2,1)

*    CALL BATCH.BUILD.LIST('', SEL.LIST)
    EB.Service.BatchBuildList('', SEL.LIST) ;*R22 Manual Conversion

RETURN
END
