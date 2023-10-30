* @ValidationCode : MjotNzI5NTE1NTM6Q3AxMjUyOjE2OTgzMDY0MzU5MjE6MzMzc3U6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 26 Oct 2023 13:17:15
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
$PACKAGE APAP.TFS
*-----------------------------------------------------------------------------
* <Rating>-60</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE GET.LOC.REF.UPDATE(OFS.BODY)

* Subroutine to Create OFS Message for FT,DC,TT based on the value from
* R.NEW.
*
* MV.NO - The Multi Value Number or the Line Number to be processed
*
*=======================================================================
*
* Modification History:
*
* 08/05/09    - Anitha.S
*               New Development
*
* 23/6/09     - Anitha.S
*             - Code amended to check if any of the local ref is present in SS by setting flag to 1
*Modification History:
*DATE                 WHO                    REFERENCE                     DESCRIPTION
*26/10/2023         Suresh             R22 Manual Conversion           USPLATFORM.BP  File Removed
*=======================================================================

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INCLUDE I_F.T24.FUND.SERVICES ;*R22 Manual Conversion

MAIN:
    GOSUB INIT
    GOSUB SS.SEL.TFS
    GOSUB SS.CHK.DC
    GOSUB TXN.SEL
    GOSUB FORM.OFS
RETURN

INIT:
    AML.CUS.NO='' ; AML.FIRST.NM='' ; AML.LAST.NM=''
    AML.ID.TYPE='' ; AML.ID.NO='' ; AML.ID.ISSU='';DC.NO.POS='' ;*23/6/09 ANITHA S ISSUE HD0916445
RETURN


SS.SEL.TFS:
    CALL GET.LOC.REF('T24.FUND.SERVICES','COND.CUS.NO',CUS.NO.POS)
    CALL GET.LOC.REF('T24.FUND.SERVICES','COND.FIRST.NM',FIRST.NM.POS)
    CALL GET.LOC.REF('T24.FUND.SERVICES','COND.LAST.NM',LAST.NM.POS)
    CALL GET.LOC.REF('T24.FUND.SERVICES','COND.ID.TYPE',ID.TYPE.POS)
    CALL GET.LOC.REF('T24.FUND.SERVICES','COND.ID.NO',ID.NO.POS)
    CALL GET.LOC.REF('T24.FUND.SERVICES','COND.ID.ISSU',ID.ISSU.POS)
    IF CUS.NO.POS THEN FLAG=1 ;*anitha s 23/6/2009
RETURN

*23/6/09 S ANITHA FOR ISSUE HD0916445
SS.CHK.DC:
    CALL GET.LOC.REF('DATA.CAPTURE','COND.CUS.NO',DC.NO.POS)
    IF DC.NO.POS THEN
        FLAG=1
    END ELSE
        FLAG=0
    END
RETURN
*23/6/09 E ANITHA FOR ISSUE HD0916445


TXN.SEL:
    AML.CUS.NO=R.NEW(TFS.LOCAL.REF) <1,CUS.NO.POS>
    AML.FIRST.NM=R.NEW(TFS.LOCAL.REF) <1,FIRST.NM.POS>
    AML.LAST.NM=R.NEW(TFS.LOCAL.REF) <1,LAST.NM.POS>
    AML.ID.TYPE=R.NEW(TFS.LOCAL.REF) <1,ID.TYPE.POS>
    AML.ID.NO=R.NEW(TFS.LOCAL.REF) <1,ID.NO.POS>
    AML.ID.ISSU=R.NEW(TFS.LOCAL.REF) <1,ID.ISSU.POS>
RETURN

FORM.OFS:
    IF FLAG=1 THEN  ;*anitha s 23/6/2009
        OFS.BODY = 'COND.CUS.NO:1:1=' : AML.CUS.NO :','
        OFS.BODY:= 'COND.FIRST.NM:1:1=' : AML.FIRST.NM :','
        OFS.BODY:= 'COND.LAST.NM:1:1=' : AML.LAST.NM :','
        OFS.BODY:= 'COND.ID.TYPE:1:1=' : AML.ID.TYPE :','
        OFS.BODY:= 'COND.ID.NO:1:1=' : AML.ID.NO :','
        OFS.BODY:= 'COND.ID.ISSU:1:1=' : AML.ID.ISSU :','
    END
RETURN



