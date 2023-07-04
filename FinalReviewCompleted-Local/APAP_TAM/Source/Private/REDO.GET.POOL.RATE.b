* @ValidationCode : Mjo0OTEwMjMxNTY6Q3AxMjUyOjE2ODA3NjAzMzYwNDc6SVRTUzotMTotMTowOjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 06 Apr 2023 11:22:16
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE REDO.GET.POOL.RATE(Y.CURRENCY,Y.REVIEW.FREQ,Y.RATE)
*-----------------------------------------------------------------------------
* Description: This routine is to return the pool rate for the currency and the term passed.

* Input Arg  : Y.CURRENCY -> Currency
*              Y.REVIEW.FREQ -> Term
* Output Arg : Y.RATE -> Rate from pool table.

* Modification History :
*------------------------------------------------------------------------
*  DATE             WHO                   REFERENCE                          DESCRIPTION
* 26-DEC-2011     H GANESH              PACS00164151 - B.16                Initial Draft.
* 06.04.2023      Conversion Tool           R22                           Auto Conversion     - FM TO @FM, ++ TO += 1
* 06.04.2023      Shanmugapriya M           R22                           Manual Conversion   - No changes
*
*------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.POOL.RATE

    IF Y.CURRENCY AND Y.REVIEW.FREQ ELSE
        RETURN
    END

    GOSUB OPEN.FILES
    GOSUB PROCESS

RETURN
*------------------------------------------
OPEN.FILES:
*------------------------------------------

    Y.RATE = ''
    Y.TERM.DATES = ''
    Y.FLAG = ''

    FN.POOL.RATE = 'F.REDO.POOL.RATE'
    F.POOL.RATE = ''
    CALL OPF(FN.POOL.RATE,F.POOL.RATE)

RETURN
*------------------------------------------
PROCESS:
*------------------------------------------

    CALL CACHE.READ(FN.POOL.RATE,Y.CURRENCY,R.REDO.POOL.RATE,F.POOL.RATE)
    Y.TERMS          = R.REDO.POOL.RATE<PL.RATE.TERM>
    Y.ASSET.RATE     = R.REDO.POOL.RATE<PL.RATE.ASSET.RATE>
    Y.LIABILITY.RATE = R.REDO.POOL.RATE<PL.RATE.LIABILITY.RATE>

    GOSUB CALC.RATE

RETURN
*--------------
CALC.RATE:
*--------------

    NO.OF.TERMS = DCOUNT(Y.TERMS,@VM)
    Y.LOOP1 = 1
    LOOP
    WHILE Y.LOOP1 LE NO.OF.TERMS
        IF Y.REVIEW.FREQ EQ Y.TERMS<1,Y.LOOP1> THEN
            Y.NEAREST = Y.TERMS<1,Y.LOOP1>
            Y.RATE = Y.ASSET.RATE<1,Y.LOOP1>:@FM:Y.LIABILITY.RATE<1,Y.LOOP1>:@FM:Y.NEAREST
            Y.FLAG = 1
        END
        Y.TT = Y.TERMS<1,Y.LOOP1>
        CALL CALENDAR.DAY(TODAY,'+',Y.TT)
        Y.TERM.DATES<1,-1> = Y.TT
        Y.LOOP1 += 1           ;** R22 Auto conversion - ++ TO += 1
    REPEAT
    IF Y.FLAG ELSE
        GOSUB GET.NEAREST
    END

RETURN
*-----------------
GET.NEAREST:
*-----------------
    Y.TT = Y.REVIEW.FREQ
    CALL CALENDAR.DAY(TODAY,'+',Y.TT)
    Y.REVIEW.DATE = Y.TT

    YDAYS = ''
    YREGION = ''
    Y.PREV.DIFF = ''
    Y.LOOP1 = 1
    LOOP
    WHILE Y.LOOP1 LE NO.OF.TERMS
        YDATE = Y.REVIEW.DATE
        YDATE2 = Y.TERM.DATES<1,Y.LOOP1>
        IF YDATE AND YDATE2 THEN
            CALL CDD (YREGION,YDATE,YDATE2,YDAYS)
        END
        YDAYS = ABS(YDAYS)
        IF Y.PREV.DIFF EQ '' THEN
            Y.NEAREST = Y.TERMS<1,Y.LOOP1>
            Y.PREV.DIFF = YDAYS
            Y.RATE = Y.ASSET.RATE<1,Y.LOOP1>:@FM:Y.LIABILITY.RATE<1,Y.LOOP1>:@FM:Y.NEAREST
        END ELSE
            IF YDAYS LT Y.PREV.DIFF THEN
                Y.NEAREST = Y.TERMS<1,Y.LOOP1>
                Y.PREV.DIFF = YDAYS
                Y.RATE = Y.ASSET.RATE<1,Y.LOOP1>:@FM:Y.LIABILITY.RATE<1,Y.LOOP1>:@FM:Y.NEAREST
            END
        END
        Y.LOOP1 += 1
    REPEAT
RETURN
END
