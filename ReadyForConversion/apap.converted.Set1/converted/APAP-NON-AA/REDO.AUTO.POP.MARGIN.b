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
*
*
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
