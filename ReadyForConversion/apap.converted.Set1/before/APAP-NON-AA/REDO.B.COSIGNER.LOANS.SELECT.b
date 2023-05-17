*-----------------------------------------------------------------------------
* <Rating>-15</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE REDO.B.COSIGNER.LOANS.SELECT
*-----------------------------------------------------------------------------------------------------------------
* Description           : This routine is used to select Arrangement records using the fields PRODCT.LINE,PRODUCT.GROUP,
*                         PRODUCT and ARR.STATUS
*
* Developed By          : Saranraj S
*
* Development Reference : DE04
*
* Attached To           : BATCH>BNK/.B.COSIGNER.LOANS
*
* Attached As           : Batch Routine
*-----------------------------------------------------------------------------------------------------------------
*------------------------
* Input Parameter:
* ---------------*
* Argument#1 : NA
* Argument#2 : NA
* Argument#3 : NA
*-----------------------------------------------------------------------------------------------------------------
*-----------------*
* Output Parameter:
* ----------------*
* Argument#4 : NA
* Argument#5 : NA
* Argument#6 : NA
*-----------------------------------------------------------------------------------------------------------------
*  M O D I F I C A T I O N S
* ***************************
*-----------------------------------------------------------------------------------------------------------------
* Defect Reference       Modified By                    Date of Change        Change Details
*(RTC/TUT/PACS)                                        (YYYY-MM-DD)
*-----------------------------------------------------------------------------------------------------------------
* PACS00325162           Ashokkumar.V.P                 04/11/2014            Additional AA product and fixed field issue
* PACS00460181           Ashokkumar.V.P                 26/05/2015            Changes the fields based on new mapping
*-----------------------------------------------------------------------------------------------------------------
* Include files
*-----------------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.DATES
    $INSERT TAM.BP I_REDO.B.COSIGNER.LOANS.COMMON

    GOSUB PROCESS
    RETURN
*-------
PROCESS:
*-------
    CALL EB.CLEAR.FILE(FN.DR.REG.DE04.WORKFILE, F.DR.REG.DE04.WORKFILE)
    LIST.PARAMETER = ''

*    Y.LAST.WORK.DAY = R.DATES(EB.DAT.LAST.WORKING.DAY)
    LIST.PARAMETER<2> = "F.AA.ARRANGEMENT"
*    LIST.PARAMETER<3> = "START.DATE LE ":Y.LAST.WORK.DAY
*    LIST.PARAMETER<3> := " AND (PRODUCT.GROUP EQ ":"CONSUMO":" OR PRODUCT.GROUP EQ ":"COMERCIAL":" OR PRODUCT.GROUP EQ ":"HIPOTECARIO":" OR PRODUCT.GROUP EQ ":"LINEAS.DE.CREDITO":")"
    LIST.PARAMETER<3> := "PRODUCT.LINE EQ ":"LENDING"
*    LIST.PARAMETER<3> := " AND ((ARR.STATUS EQ ":"CURRENT":") OR (ARR.STATUS EQ ":"EXPIRED":"))"
    CALL BATCH.BUILD.LIST(LIST.PARAMETER, "")

    RETURN
*-------------------------------------------End Of Record------------------------------------------------------------
END
