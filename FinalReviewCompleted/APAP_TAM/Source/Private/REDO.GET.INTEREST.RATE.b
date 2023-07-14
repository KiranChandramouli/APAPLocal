* @ValidationCode : MjotMjAyMDk5MDQxNzpDcDEyNTI6MTY4Mzg5MjYyNTI0NTpJVFNTMTotMTotMTowOjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 12 May 2023 17:27:05
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS1
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE REDO.GET.INTEREST.RATE(ARR.ID,INT.RATE)
*---------------------------------------------------
* Description: Routine to get the interest rate of an arrangement.
*---------------------------------------------------
* Input Arg: Arrangement ID.
* Output Arg: Interest Rate.
*---------------------------------------------------
* Modification History :
*   Date            Who                   Reference               Description
* 09 Dec 2011    H Ganesh               PACS00149083 - B.16    Initial Draft.
** 10-04-2023 R22 Auto Conversion no changes
** 10-04-2023 Skanda R22 Manual Conversion - No changes
*---------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.AA.INTEREST
    $USING APAP.AA

    GOSUB PROCESS
RETURN
*---------------------------------------------------
PROCESS:
*---------------------------------------------------
    GOSUB GET.PROPERTY

    Y.ARRG.ID = ARR.ID
    PROPERTY.CLASS = 'INTEREST'
    PROPERTY = Y.PRIN.PROP
    EFF.DATE = ''
    ERR.MSG = ''
    R.INT.ARR.COND = ''
*    CALL REDO.CRR.GET.CONDITIONS(Y.ARRG.ID,EFF.DATE,PROPERTY.CLASS,PROPERTY,R.INT.ARR.COND,ERR.MSG)
    APAP.AA.redoCrrGetConditions(Y.ARRG.ID,EFF.DATE,PROPERTY.CLASS,PROPERTY,R.INT.ARR.COND,ERR.MSG) ;* R22 Manual Conversion
    INT.RATE = R.INT.ARR.COND<AA.INT.EFFECTIVE.RATE,1>

RETURN
*---------------------------------------------------
GET.PROPERTY:
*---------------------------------------------------
* To get the interest property.

    PROP.NAME='PRINCIPAL'       ;* Interest Property to obtain
*    CALL REDO.GET.INTEREST.PROPERTY(ARR.ID,PROP.NAME,OUT.PROP,ERR)
    APAP.TAM.redoGetInterestProperty(ARR.ID,PROP.NAME,OUT.PROP,ERR) ;* R22 Manual Conversion
    Y.PRIN.PROP=OUT.PROP        ;* This variable hold the value of principal interest property

RETURN
END
