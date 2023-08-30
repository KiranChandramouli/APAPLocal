* @ValidationCode : MjotNzMwMTQ5MTI5OkNwMTI1MjoxNjgwNjg5ODI0OTg5OnNhbWFyOi0xOi0xOjA6MDpmYWxzZTpOL0E6REVWXzIwMjEwOC4wOi0xOi0x
* @ValidationInfo : Timestamp         : 05 Apr 2023 15:47:04
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : samar
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOVER
SUBROUTINE REDO.AUTO.POP.MARGIN
*
*
* Description
* This a Validation routine for REDO.RATE.CHANGE.CRIT,INPUT version
*
* This auto populates the MARGIN.TYPE field with SINGLE while validating
*
*
*----------------------------------------------------------------------------------------
* Input/Output:
*--------------
* IN : -NA-
* OUT : -NA-
*---------------
*-----------------------------------------------------------------------------------------------------------------
* Modification History :
*   Date            Who                   Reference               Description
*   ------         ------               -------------            -------------
* 02 Jul 2011    Ravikiran AV              PACS00055828          Populate the field MARGIN.TYPE with SINGLE
*05-04-2023  Conversion Tool            R22 Auto Code conversion        VM TO @VM
*05-04-2023      Samaran T              Manual R22 Code Conversion         No Changes
*-------------------------------------------------------------------------------------------------------------------
*
* All File INSERTS done here
*

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.RATE.CHANGE.CRIT

*------------------------------------------------------------------------------------------------------------------
*Main Logic of the routine
*

MAIN.LOGIC:

    GOSUB POPULATE.MARGIN

RETURN
*------------------------------------------------------------------------------------------------------------------
* Populate the MARGIN.TYPE field
*

POPULATE.MARGIN:

    MARGIN.COUNT = DCOUNT(R.NEW(RATE.CHG.ORG.AMT.ST.RG),@VM)   ;*Get the Count of MV

    FOR LOOP.CNT = 1 TO MARGIN.COUNT

        R.NEW(RATE.CHG.MARGIN.TYPE)<1,LOOP.CNT> = 'SINGLE'      ;* Loop each MV set and populate the field with SINGLE
        IF R.NEW(RATE.CHG.PROP.SPRD.CHG)<1,LOOP.CNT> EQ '' AND R.NEW(RATE.CHG.PROP.INT.CHG)<1,LOOP.CNT> EQ '' THEN
            AF = RATE.CHG.PROP.SPRD.CHG
            AV = LOOP.CNT
            ETEXT ='EB-REDO.MAN.INP.MISS'
            CALL STORE.END.ERROR
        END

    NEXT LOOP.CNT

RETURN
*------------------------------------------------------------------------------------------------------------------

END
