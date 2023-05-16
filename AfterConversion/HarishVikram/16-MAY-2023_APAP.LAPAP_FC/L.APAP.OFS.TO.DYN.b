* @ValidationCode : MjoyMDAwNzQyNzkwOkNwMTI1MjoxNjg0MTQyMTUzNTg1OkhhcmlzaHZpa3JhbUM6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 15 May 2023 14:45:53
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : HarishvikramC
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
SUBROUTINE  L.APAP.OFS.TO.DYN(Y.OFS.OUT.RESPONSE, Y.OBJECT.TYPE, Y.DYN.RESPONSE.KEY, Y.DYN.RESPONSE.VALUE, Y.ERROR)
*------------------------------------------------------------------------
* Modification History :
*------------------------------------------------------------------------
*  DATE             WHO                   REFERENCE
* 21-APRIL-2023      Conversion Tool       R22 Auto Conversion - CHAR to CHARX , Include to Insert and T24.BP is removed from Insert
* 13-APRIL-2023      Harsha                R22 Manual Conversion - No changes
*------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE

*Subroutine Convert a OFS to Dynamic Array
*----------------------------------------------------------------------------------------------------------------------------------------------------
*CLEAR OUTPUT VARIABLES
    Y.DYN.RESPONSE.KEY = ''
    Y.DYN.RESPONSE.VALUE = ''
    Y.ERROR = ''
    Y.ERROR <3> = 'L.APAP.OFS.TO.DYN'

    V.I = 0
    V.J = 0
    V.K = 0

    Y.REL = 0
    Y.POS = 0

    Y.KEY = ''
    Y.ITEM = ''

*DEBUG
    BEGIN CASE
        CASE Y.OBJECT.TYPE EQ 'VERSION'
            GOSUB READ.VERSION
        CASE Y.OBJECT.TYPE EQ 'ENQUIRY'
            GOSUB READ.ENQUIRY
        CASE 1
            Y.ERROR<1> = 1
            Y.ERROR<2> = 'INVALID OBJECT TYPE'
    END CASE

RETURN

READ.VERSION:
*DEBUG
    Y.OFS = Y.OFS.OUT.RESPONSE
    CHANGE ',' TO @FM IN Y.OFS
    CHANGE '/' TO @VM IN Y.OFS<1>
    CHANGE ':' TO @VM IN Y.OFS
    CHANGE '=' TO @VM IN Y.OFS

    Y.CNT =  DCOUNT(Y.OFS,@FM)

    Y.DYN.RESPONSE.KEY<1> = '@ID'
    Y.DYN.RESPONSE.VALUE<1> = Y.OFS<1,1>
    FOR V.I = 2 TO Y.CNT STEP 1

        V.J = Y.OFS<V.I,2>
        V.K = Y.OFS<V.I,3>

        Y.KEY = Y.OFS<V.I,1>
        LOCATE Y.KEY IN Y.DYN.RESPONSE.KEY<1> SETTING Y.POS THEN
            Y.REL += 1
        END
        ELSE
            Y.POS = V.I - Y.REL
        END

        Y.DYN.RESPONSE.KEY<Y.POS> = Y.KEY
        Y.DYN.RESPONSE.VALUE<Y.POS,V.J,V.K> = Y.OFS<V.I,4>

    NEXT V.I

RETURN

READ.ENQUIRY:
*DEBUG
    Y.OFS = Y.OFS.OUT.RESPONSE
    CHANGE ',' TO @FM IN Y.OFS

    Y.OFS.KEY.LBL = Y.OFS<2>
    CHANGE '/' TO @FM IN Y.OFS.KEY.LBL
    CHANGE '::' TO @VM IN Y.OFS.KEY.LBL

    Y.CNT =  DCOUNT(Y.OFS,@FM)
    FOR V.I = 3 TO Y.CNT  STEP 1
        Y.ITEM = Y.OFS<V.I>
        CHANGE CHARX(9) TO @VM IN Y.ITEM
        Y.OFS.ROW<-1> = Y.ITEM
    NEXT V.I

*DEBUG
    Y.CNT =  DCOUNT(Y.OFS.KEY.LBL,@FM)
    FOR V.I = 1 TO Y.CNT
        Y.DYN.RESPONSE.KEY<V.I> = Y.OFS.KEY.LBL<V.I,1>
        Y.CNT.ROW = DCOUNT(Y.OFS.ROW,@FM)
        FOR V.J = 1 TO Y.CNT.ROW
*CLEAN DATA
            Y.ITEM = Y.OFS.ROW<V.J,V.I>
            Y.ITEM = TRIM(Y.ITEM,'"','B')
            Y.ITEM = TRIM(Y.ITEM,' ','B')
            Y.DYN.RESPONSE.VALUE<V.I,V.J> = Y.ITEM
        NEXT V.J
    NEXT V.I

RETURN

RETURN
END
