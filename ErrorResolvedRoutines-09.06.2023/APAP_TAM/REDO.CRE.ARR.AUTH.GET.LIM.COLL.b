* @ValidationCode : MjoxODY0NjY0NjMyOkNwMTI1MjoxNjg2MzA5MjkyOTcwOklUU1MxOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIyX1NQNS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 09 Jun 2023 16:44:52
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS1
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R22_SP5.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
*-----------------------------------------------------------------------------
* <Rating>-43</Rating>
*-----------------------------------------------------------------------------
$PACKAGE APAP.TAM
SUBROUTINE REDO.CRE.ARR.AUTH.GET.LIM.COLL
*----------------------------------------------------------------------------------------------------
* DESCRIPTION :
*              This is related with REDO.CREATE.ARRANGEMENT.AUTHORISE routine
*              In this code we assign the SEQ values for creating LIMIT and COLLATERAL
*-----------------------------------------------------------------------------------------------------
* Input / Output
* --------------
* IN Parameter    : NA
* OUT Parameter   :
*                     E          is equals to "" then everything OK
*                     R.NEW      information for creating the LIMIT
*-----------------------------------------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : hpasquel@temenos.com
* PROGRAM NAME : REDO.CREATE.ARRANGEMENT.VALIDATE
*-----------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
* Date             Author             Reference         Description
* 05-Jan-2011    Paul Pasquel      ODR-2009-11-0199    Initial creation
* 09.06.2023    Santosh         R22 Manual Conversion  Added package, changed prefix REDO.CR to REDO.FC as per i_file.
*------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_F.REDO.CREATE.ARRANGEMENT

    GOSUB PROCESS

RETURN
*------------------------------------------------------------------------------------------------------
PROCESS:
*------------------------------------------------------------------------------------------------------
* IF R.NEW(REDO.CR.LIMIT) NE '' THEN
    IF R.NEW(REDO.FC.ID.LIMIT) NE '' THEN ;**R22 Manual Conversion
        CALL OCOMO("LIMIT WAS ALREADY ASSOCIATED, THEN OMMIT THIS PROCESS")
        RETURN
    END
* Get Limit Product for the given category code
    YPRODUCT = ''
    E = ""
    GOSUB GET.LIMIT.PRODUCT
    IF E NE "" THEN
        RETURN
    END
* Set Limit information
*   R.NEW(REDO.CR.LIMIT) = YPRODUCT
    R.NEW(REDO.FC.ID.LIMIT) = YPRODUCT ;**R22 Manual Conversion
* Collateral must be created ?
*    IF R.NEW(REDO.CR.COLL.CODE) NE '' THEN
    IF R.NEW(REDO.FC.COLLATERAL.CODE) NE '' THEN ;**R22 Manual Conversion
*       R.NEW(REDO.CR.COLL.RIGHT.ID) = R.NEW(REDO.CR.CUSTOMER) : "." : P.LAST.COLL.ID
*       R.NEW(REDO.CR.SEC.NO) = R.NEW(REDO.CR.COLL.RIGHT.ID) : ".1"

        R.NEW(REDO.FC.ID.COLLATERL.RIGHT) = R.NEW(REDO.FC.CUSTOMER) : "." : P.LAST.COLL.ID ;**R22 Manual Conversion
        R.NEW(REDO.FC.SEC.VALUE.DE) = R.NEW(REDO.FC.ID.COLLATERL.RIGHT) : ".1" ;**R22 Manual Conversion
    END ELSE
*       R.NEW(REDO.CR.COLL.RIGHT.ID) = ''
*       R.NEW(REDO.CR.SEC.NO) = ''

        R.NEW(REDO.FC.ID.COLLATERL.RIGHT) = '' ;**R22 Manual Conversion
        R.NEW(REDO.FC.SEC.VALUE.DE) = '' ;**R22 Manual Conversion
    END
*   R.NEW(REDO.CR.APPRVL.DATE) = TODAY
*   R.NEW(REDO.CR.OFFRD.UNTIL) = TODAY
*   Y.MAT.DATE = R.NEW(REDO.CR.TERM)
*   CALL CALENDAR.DAY(R.NEW(REDO.CR.EFFECT.DATE),'+',Y.MAT.DATE)
*   R.NEW(REDO.CR.LIM.EXP.DATE) = Y.MAT.DATE
*   R.NEW(REDO.CR.NOTES) = "CREADO POR FABRICA DE CREDITO"
*   R.NEW(REDO.CR.INTRNL.AMT) = R.NEW(REDO.CR.AMOUNT)
*   R.NEW(REDO.CR.MAX.TOTAL) = R.NEW(REDO.CR.INTRNL.AMT)
*   R.NEW(REDO.CR.AVAIL.MKR) = "Y"
*    R.NEW(REDO.CR.COLL.CODE) = R.NEW(REDO.CR.TYPE.OF.SEC)<1,1>

**R22 Manual Conversion - Start
    R.NEW(REDO.FC.APPROVAL.DATE) = TODAY
    R.NEW(REDO.FC.OFFERED.UNTIL) = TODAY
    Y.MAT.DATE = R.NEW(REDO.FC.TERM)
    CALL CALENDAR.DAY(R.NEW(REDO.FC.EFFECT.DATE),'+',Y.MAT.DATE)
    R.NEW(REDO.FC.EXPIRY.DATE) = Y.MAT.DATE
    R.NEW(REDO.FC.NOTES) = "CREADO POR FABRICA DE CREDITO"
    R.NEW(REDO.FC.INTERNAL.AMOUNT) = R.NEW(REDO.FC.AMOUNT)
    R.NEW(REDO.FC.MAXIMUM.TOTAL) = R.NEW(REDO.FC.INTERNAL.AMOUNT)
    R.NEW(REDO.FC.AVAILABLE.MARKER) = "Y"
**R22 Manual Conversion - End
RETURN

*------------------------------------------------------------------------------------------------------
GET.LIMIT.PRODUCT:
*------------------------------------------------------------------------------------------------------
* Backup COMMON variables
*
* We could not use LIMIT.GET.PRODUCT because it launchs an error messagen when more than 1 limite is applicable for the contract
*
*    DIM SAVE.R.NEW(C$SYSDIM)
*    Y.OLD.APPLICATION = APPLICATION
*    MAT SAVE.R.NEW = MAT R.NEW
*    Y.DUMMY = ''
*    MATPARSE R.NEW FROM Y.DUMMY         ;* Clean all the dim array
*    APPLICATION = "ACCOUNT"
*    R.NEW(AC.CATEGORY) = SAVE.R.NEW(REDO.CR.CATEGORY)

* Call to get Limit Product
    YPRODUCT = ""
    YR.SYSTEM = ""
    E = ''
*    CALL LIMIT.GET.PRODUCT (YR.SYSTEM, SAVE.R.NEW(REDO.CR.CUSTOMER), SAVE.R.NEW(REDO.CR.LOAN.CURRENCY), YPRODUCT)
*   CALL REDO.R.GET.LIMIT.PRODUCT("ACCOUNT", R.NEW(REDO.CR.CATEGORY), YPRODUCT)
    APAP.TAM.redoRGetLimitProduct("ACCOUNT", R.NEW(REDO.FC.CIUU.CATEG), YPRODUCT) ;*R22 Manual Conversion

* Restore COMMON variables
*    MAT R.NEW = MAT SAVE.R.NEW
*    APPLICATION =Y.OLD.APPLICATION

* After restoring, check if LIMIT.GET.PRODUCT found an error
    IF E NE '' THEN
*       AF = REDO.CR.LIMIT
        AF = REDO.FC.ID.LIMIT ;**R22 Manual Conversion
        ETEXT = E
        CALL STORE.END.ERROR
        CALL OCOMO("ERROR TRYING TO GET PRODUCT.LIMIT FOR THE CURRENT CONTRACT")
        RETURN
    END
* Get the next sequence to use for creating the LIMIT
*    YPRODUCT  = YPRODUCT[".",1,1]
*   P.CUSTOMER.ID = R.NEW(REDO.CR.CUSTOMER)
    P.CUSTOMER.ID = R.NEW(REDO.FC.CUSTOMER) ;**R22 Manual Conversion
    P.LIMIT.REF = YPRODUCT
    P.ACTION = 'R'
    P.LAST.ID = ''
    P.LAST.COLL.ID = ''
*    CALL REDO.R.CRE.ARR.LIMIT.SEQ.UPD(P.CUSTOMER.ID, P.LIMIT.REF, P.ACTION, P.LAST.ID, P.LAST.COLL.ID)
    APAP.TAM.redoRCreArrLimitSeqUpd(P.CUSTOMER.ID, P.LIMIT.REF, P.ACTION, P.LAST.ID, P.LAST.COLL.ID) ;**R22 Manual Conversion
    
    P.LAST.ID = P.LAST.ID + 1
    P.LAST.ID = FMT(P.LAST.ID,"R%2")
    YPRODUCT  = YPRODUCT : "." : P.LAST.ID
* Calculate the next Collateral.Id
    P.LAST.COLL.ID ++

RETURN
*------------------------------------------------------------------------------------------------------
END
