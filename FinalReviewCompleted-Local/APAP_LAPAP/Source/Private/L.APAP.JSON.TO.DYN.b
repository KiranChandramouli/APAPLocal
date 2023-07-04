* @ValidationCode : MjotODQ4NzI2MDg1OkNwMTI1MjoxNjg0MjIyNzkzNDI1OklUU1M6LTE6LTE6LTI4OjE6ZmFsc2U6Ti9BOkRFVl8yMDIxMDguMDotMTotMQ==
* @ValidationInfo : Timestamp         : 16 May 2023 13:09:53
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : -28
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
SUBROUTINE L.APAP.JSON.TO.DYN(JSON.REQUEST, Y.DYN.REQUEST.KEY, Y.DYN.REQUEST.VALUE, Y.DYN.REQUEST.TYPE, Y.ERROR)
*------------------------------------------------------------------------
* Modification History :
*------------------------------------------------------------------------
*  DATE             WHO                   REFERENCE
* 21-APRIL-2023      Conversion Tool       R22 Auto Conversion - Include to Insert , = to EQ , > to GT and T24.BP is removed from Insert
* 21-APRIL-2023      Harsha                R22 Manual Conversion - CALL RTN FORMAT MODIFIED
*------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE

*Subroutine Convert a Json Request to Dynamic Array.
*----------------------------------------------------------------------------------------------------------------------------------------------------
    Y.UNROLL.ARRAY = ''

    Y.REQUEST.KV1 = ''
    Y.REQUEST.KV2 = ''
    Y.REQUEST.KV3 = ''

    Y.DYN.REQUEST.KEY = ''
    Y.DYN.REQUEST.VALUE = ''
    Y.DYN.REQUEST.TYPE = ''

    Y.DEPTH = 0

    CT.I = 0
    CT.J = 0
    CT.K = 0

*CLEAR OUTPUTS VARIABLES
    Y.DYN.REQUEST.KEY = ''
    Y.DYN.REQUEST.VALUE = ''
    Y.DYN.REQUEST.TYPE = ''
    Y.ERROR = ''
    Y.ERROR<3> = 'L.APAP.JSON.TO.DYN'


*DEBUG
    GOSUB PROCESS.DEPTH1
RETURN


PROCESS.DEPTH1:
*CALL APAP.LAPAP.L.APAP.JSON.PARSE(JSON.REQUEST, Y.REQUEST.KV1 , Y.UNROLL.ARRAY, Y.ERROR)
    CALL APAP.LAPAP.lApapJsonParse(JSON.REQUEST, Y.REQUEST.KV1 , Y.UNROLL.ARRAY, Y.ERROR);*R22 Manual Conversion - Added APAP.LAPAP

    CNT_FM1 = DCOUNT(Y.REQUEST.KV1<1>, @VM)
    Y.TYPE = ''
    Y.DEPTH = 1

*DEBUG
    IF CNT_FM1 EQ 0 THEN
        Y.ERROR<1> = 1
        Y.ERROR<2> = "BLANK MESSAGE"
        RETURN
    END

    FOR CT.I = 1 TO CNT_FM1 STEP 1
*DEBUG
        Y.DYN.REQUEST.KEY<CT.I>   = Y.REQUEST.KV1<1,CT.I>

        Y.TYPE                    = Y.REQUEST.KV1<3,CT.I>
        BEGIN CASE
            CASE Y.TYPE EQ 'ARRAY'
                GOSUB PROCESS.DEPTH2
                IF Y.ERROR<1> EQ 1 THEN
                    RETURN
                END
            CASE Y.TYPE EQ 'OBJECT'
                Y.ERROR<1> = 1
                Y.ERROR<2> = 'INVALID JSON MESSAGE, THE MESSAGE HAS AN INNER OBJECTS'
                RETURN
            CASE 1
                Y.DYN.REQUEST.VALUE<CT.I> = Y.REQUEST.KV1<2,CT.I>
                Y.DYN.REQUEST.TYPE <CT.I> =  Y.TYPE
        END CASE

    NEXT CT.I
RETURN

PROCESS.DEPTH2:
*DEBUG
*CALL APAP.LAPAP.L.APAP.JSON.PARSE(Y.REQUEST.KV1<2,CT.I>, Y.REQUEST.KV2, Y.UNROLL.ARRAY, Y.ERROR)
    CALL APAP.LAPAP.lApapJsonParse(Y.REQUEST.KV1<2,CT.I>, Y.REQUEST.KV2, Y.UNROLL.ARRAY, Y.ERROR);*R22 Manual Conversion - Added APAP.LAPAP

    CNT_FM2 = DCOUNT(Y.REQUEST.KV2<1>, @VM)
    Y.KEY = ''
    Y.VALUE = ''
    Y.TYPE = ''
    Y.DEPTH = 2

    IF CNT_FM2 GT 0 THEN
        CNT_VM =  DCOUNT(Y.REQUEST.KV2<2,CNT_FM2>, @SM)

        Y.KEY = Y.REQUEST.KV2<1>

        IF Y.KEY EQ 'ARRAY' THEN
            FOR CT.J = 1 TO CNT_VM STEP 1
*DEBUG
                Y.TYPE = Y.REQUEST.KV2<3,1,CT.J>

                BEGIN CASE
                    CASE Y.TYPE EQ 'ARRAY'
                        GOSUB PROCESS.DEPTH3
                        IF Y.ERROR<1> EQ  1 THEN
                            RETURN
                        END
                    CASE Y.TYPE EQ 'OBJECT'
                        Y.ERROR<1> = 1
                        Y.ERROR<2> = 'INVALID JSON MESSAGE, THE MESSAGE HAS AN INNER OBJECTS'
                        RETURN
                    CASE 1
                        Y.VALUE = Y.REQUEST.KV2<2,1,CT.J>

                        Y.DYN.REQUEST.VALUE<CT.I,CT.J> = Y.VALUE
                        Y.DYN.REQUEST.TYPE <CT.I,CT.J> = Y.TYPE
                END CASE

            NEXT CT.J
        END
        ELSE
            Y.ERROR<1> = 1
            Y.ERROR<2> = 'ARRAY PARSING ERROR'
        END
    END
    ELSE
        Y.DYN.REQUEST.VALUE<CT.I> = ''
        Y.DYN.REQUEST.TYPE <CT.I> =  Y.REQUEST.KV1<3,CT.I>
    END

RETURN

PROCESS.DEPTH3:
*DEBUG
*CALL APAP.LAPAP.L.APAP.JSON.PARSE(Y.REQUEST.KV2<2,1,CT.J>, Y.REQUEST.KV3, Y.UNROLL.ARRAY, Y.ERROR)
    CALL APAP.LAPAP.lApapJsonParse(Y.REQUEST.KV2<2,1,CT.J>, Y.REQUEST.KV3, Y.UNROLL.ARRAY, Y.ERROR);*R22 Manual Conversion - Added APAP.LAPAP

    CNT_FM3 = DCOUNT(Y.REQUEST.KV3<1>, @VM)
    Y.KEY = ''
    Y.VALUE = ''
    Y.TYPE = ''
    Y.DEPTH = 3

    IF CNT_FM3 GT 0 THEN
        CNT_SM=  DCOUNT(Y.REQUEST.KV3<2,CNT_FM3>, @SM)

        Y.KEY = Y.REQUEST.KV3<1>

        IF Y.KEY EQ  'ARRAY' THEN
            FOR CT.K = 1 TO CNT_SM STEP 1
                Y.TYPE = Y.REQUEST.KV3<3,1,CT.K>

                BEGIN CASE
                    CASE Y.TYPE EQ 'ARRAY'
                        Y.ERROR<1> = 1
                        Y.ERROR<2> = 'INVALID JSON MESSAGE, THE MESSAGE HAS A DEPTH OF MORE THAN OF 3'
                        RETURN
                    CASE Y.TYPE EQ 'OBJECT'
                        Y.ERROR<1> = 1
                        Y.ERROR<2> = 'INVALID JSON MESSAGE, THE MESSAGE HAS AN INNER OBJECTS'
                        RETURN
                    CASE 1
                        Y.VALUE = Y.REQUEST.KV3<2,1,CT.K>

                        Y.DYN.REQUEST.VALUE<CT.I,CT.J,CT.K> = Y.VALUE
                        Y.DYN.REQUEST.TYPE<CT.I,CT.J,CT.K> = Y.TYPE
                END CASE
            NEXT CT.K
        END
        ELSE
            Y.ERROR<1> = 1
            Y.ERROR<2> = 'ARRAY PARSING ERROR'
        END
    END
    ELSE
        Y.DYN.REQUEST.VALUE<CT.I, CT.J> = ''
        Y.DYN.REQUEST.TYPE<CT.I, CT.J> =  Y.REQUEST.KV2<3,CT.I,CT.J>
    END

RETURN

RETURN

END
