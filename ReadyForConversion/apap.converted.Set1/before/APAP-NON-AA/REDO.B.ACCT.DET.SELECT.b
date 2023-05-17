*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE REDO.B.ACCT.DET.SELECT
*-------------------------------------------------------------------------------
* Company Name      : PAGE SOLUTIONS, INDIA
* Developed By      : Nirmal.P
* Reference         :
*-------------------------------------------------------------------------------
* Subroutine Type   : B
* Attached to       :
* Attached as       : Multi threaded Batch Routine..
*-------------------------------------------------------------------------------
* Input / Output :
*----------------
* IN     :
* OUT    :
*-------------------------------------------------------------------------------
*  M O D I F I C A T I O N S
* ***************************
*-----------------------------------------------------------------------------------------------------------------
* Defect Reference       Modified By                    Date of Change        Change Details
*(RTC/TUT/PACS)                                        (YYYY-MM-DD)
*-----------------------------------------------------------------------------------------------------------------
* PACS00361294          Ashokkumar.V.P                  14/11/2014           Changes based on mapping.
*-----------------------------------------------------------------------------------------------------------------
    $INSERT T24.BP I_COMMON
    $INSERT T24.BP I_EQUATE
    $INSERT TAM.BP I_REDO.B.ACCT.DET.COMMON
    $INSERT TAM.BP I_F.REDO.H.REPORTS.PARAM

*
    CA.POS = ''
    Y.FIELD.NAME = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.FIELD.NAME>
    Y.FIELD.NAME = CHANGE(Y.FIELD.NAME,VM,FM)
    LOCATE 'CA.SEL.CODES' IN Y.FIELD.NAME SETTING CA.POS THEN
        CATEG.LIST = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.FIELD.VALUE><1,CA.POS>
        CATEG.LIST = CHANGE(CATEG.LIST,SM,' ')
    END

    SEL.LIST = ''; NO.OF.REC1 = ''; ACC.ERR1 = ''
    SEL.CMD1 = "SELECT ":FN.ACCOUNT:" WITH CATEGORY EQ ":CATEG.LIST
    CALL EB.READLIST(SEL.CMD1,SEL.LIST,'',NO.OF.REC1,ACC.ERR1)
    CALL BATCH.BUILD.LIST("",SEL.LIST)
    RETURN
END
