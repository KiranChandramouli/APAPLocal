* @ValidationCode : MjoxNzUyMTM4Nzg2OkNwMTI1MjoxNzAyOTYzOTkwNjEwOjMzM3N1Oi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 19 Dec 2023 11:03:10
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : 333su
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.DRREG
SUBROUTINE DR.REG.RIEN9.EXTRACT.FILTER(REC.ID)
*-----------------------------------------------------------------------------
* Company Name   : APAP
* Developed By   :
* Program Name   : DR.REG.RIEN9.EXTRACT
* Date           : 10-June-2013
*-----------------------------------------------------------------------------
* Description:
*------------
* Dont process AA.ARR.OVERDUE>L.LOAN.STATUS1 NE "3".
* Byron - PACS00313072 - Right spec is Dont process AA.ARR.OVERDUE>L.LOAN.STATUS1 EQ "Writte-Off"
*-----------------------------------------------------------------------------
*
* Modification History :
* ----------------------
* Date              Author                    Description
* ==========        ====================      ============
* 28-08-2014        Ashokkumar                PACS00313072- Fixed all the fields
*---------------------------------------------------------------------------------------
*DATE               WHO                       REFERENCE                 DESCRIPTION
*10-04-2023       CONVERSION TOOLS            AUTO R22 CODE CONVERSION   NO CHANGE
*10-04-2023       AJITHKUMAR                  MANUAL R22 CODE CONVERSION NO CHANGE
*14/12/2023       Suresh                      R22 Manual Conversion      CALL routine format modified

*----------------------------------------------------------------------------------------
*-----------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_BATCH.FILES
    $INSERT I_F.AA.OVERDUE
    $INSERT I_DR.REG.RIEN9.EXTRACT.COMMON
    
    
    $USING AA.Framework ;*R22 Manual Conversion

    BEGIN CASE

        CASE CONTROL.LIST<1,1> EQ "AA.DETAIL"
            ArrangementID = REC.ID
            effectiveDate = ''
            idPropertyClass = 'OVERDUE'
            idProperty = ''
            returnIds = ''
            returnConditions = ''
            returnError = ''
*          CALL AA.GET.ARRANGEMENT.CONDITIONS(ArrangementID, idPropertyClass, idProperty, effectiveDate, returnIds, returnConditions, returnError)
            AA.Framework.GetArrangementConditions(ArrangementID, idPropertyClass, idProperty, effectiveDate, returnIds, returnConditions, returnError)  ;*R22 Manual Conversion
            R.AA.OVERDUE = RAISE(returnConditions)
            L.LOAN.STATUS = R.AA.OVERDUE<AA.OD.LOCAL.REF,OD.L.LOAN.STATUS1.POS>
*        IF L.LOAN.STATUS EQ 3 THEN             ;* Byron - PACS00313072 S/E
            IF L.LOAN.STATUS EQ 'Write-Off' THEN          ;* Byron - PACS00313072 S/E
                REC.ID = ""   ;* Return NULL if L.LOAN.STATUS1 NE 3.
            END

        CASE 1
            NULL
    END CASE

RETURN

*-----------------------------------------------------------------------------
END
