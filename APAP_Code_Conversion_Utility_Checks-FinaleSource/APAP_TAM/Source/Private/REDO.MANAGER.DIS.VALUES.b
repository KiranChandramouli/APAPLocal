$PACKAGE APAP.TAM
SUBROUTINE REDO.MANAGER.DIS.VALUES
*-----------------------------------------------------------------------------------------------------------------
* Developer    : Ganesh R
* Date         : 10.02.2011
* Description  : REDO.ADMIN.DIS.VALUES
*-----------------------------------------------------------------------------------------------------------------
* Input/Output:
* -------------
* In  : --N/A--
* Out : --N/A--
*-----------------------------------------------------------------------------------------------------------------
* Dependencies:
* -------------
* Calls     : --N/A--
* Called By : --N/A--
*-----------------------------------------------------------------------------------------------------------------
* Revision History:
* -----------------
* Version          Date          Name              Description
* -------          ----          ----              ------------
*   1.0         10.05.2011      BHARATH G    Attahced as a check record routine in the versions
*   1.1         01-06-2011      Bharath G   Description added for EB.LOOKUP
** 13-04-2023 R22 Auto Conversion no changes
** 13-04-2023 Skanda R22 Manual Conversion - No changes

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.EB.LOOKUP
    $INSERT I_F.REDO.MANAGER.CHQ.DETAILS

    FN.EB.LOOKUP = 'F.EB.LOOKUP'
    F.EB.LOOKUP  = ''
    R.EB.LOOKUP  = ''
    CALL OPF(FN.EB.LOOKUP,F.EB.LOOKUP)

    T(MAN.CHQ.DET.STATUS)<2>  = "STOP.PAID.CNFRM_STOP.PAID.NON.CNFRM"

    Y.EB.LOOKUP.ID = 'MGR.CHQ.STATUS*STOP.PAID.CNFRM'
    GOSUB GET.DESCRIPTION
    Y.DESC.1 = Y.DESC

    Y.EB.LOOKUP.ID = 'MGR.CHQ.STATUS*STOP.PAID.NON.CNFRM'
    GOSUB GET.DESCRIPTION
    Y.DESC.2 = Y.DESC

    T(MAN.CHQ.DET.STATUS)<11> = Y.DESC.1:'_':Y.DESC.2

RETURN
*---------------
GET.DESCRIPTION:
*---------------
*
    CALL F.READ(FN.EB.LOOKUP,Y.EB.LOOKUP.ID,R.EB.LOOKUP,F.EB.LOOKUP,LOOKUP.ERR)
    IF R.EB.LOOKUP<EB.LU.DESCRIPTION> THEN
        Y.DESC =  R.EB.LOOKUP<EB.LU.DESCRIPTION>
    END

RETURN
*---------------------------------------------------------------------------------------------------------------
END
