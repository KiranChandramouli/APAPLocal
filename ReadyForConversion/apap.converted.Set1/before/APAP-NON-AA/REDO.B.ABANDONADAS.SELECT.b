*-----------------------------------------------------------------------------
* <Rating>-10</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE REDO.B.ABANDONADAS.SELECT
*-------------------------------------------------------------------------------
* Company Name      : PAGE SOLUTIONS, INDIA
* Developed By      : Nirmal.P
* Reference         :
*-------------------------------------------------------------------------------
* Subroutine Type   : B
* Attached to       :
* Attached as       : Multi threaded Batch Routine.
*-------------------------------------------------------------------------------
* Input / Output :
*----------------
* IN     :
* OUT    :
*-------------------------------------------------------------------------------
* Description: This is a .SELECT Subroutine
*
*-------------------------------------------------------------------------------
* Modification History
*-----------------------------------------------------------------------------------------------------------------
* Defect Reference       Modified By                    Date of Change        Change Details
*(RTC/TUT/PACS)                                        (YYYY-MM-DD)
*-----------------------------------------------------------------------------------------------------------------
* PACS00392015          Ashokkumar.V.P                  19/11/2014           Changes based on mapping.
*-----------------------------------------------------------------------------------------------------------------

    $INSERT T24.BP I_COMMON
    $INSERT T24.BP I_EQUATE
    $INSERT T24.BP I_F.DATES
    $INSERT TAM.BP I_REDO.B.ABANDONADAS.COMMON
    $INSERT TAM.BP I_F.REDO.H.REPORTS.PARAM

    GOSUB PROCESS.DATE.SELECT
    RETURN

PROCESS.DATE.SELECT:
*-------------------
    SEL.CMD = "SELECT ":FN.ACCOUNT:" WITH WORKING.BALANCE GT '0' AND L.AC.STATUS1 EQ 'ABANDONED' AND L.AC.STATUS2 EQ ''"
    LIST.ACC = ''; NO.OF.ACC = ''; ACC.ERR = ''
    CALL EB.READLIST(SEL.CMD,LIST.ACC,'',NO.OF.ACC,ACC.ERR)
    CALL BATCH.BUILD.LIST("",LIST.ACC)
    RETURN
END
