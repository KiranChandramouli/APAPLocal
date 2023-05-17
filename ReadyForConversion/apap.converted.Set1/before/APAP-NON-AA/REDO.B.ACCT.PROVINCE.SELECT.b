*-----------------------------------------------------------------------------
* <Rating>-21</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE REDO.B.ACCT.PROVINCE.SELECT
*-------------------------------------------------------------------------------
* Company Name      : PAGE SOLUTIONS, INDIA
* Developed By      :
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
*
*-------------------------------------------------------------------------------
    $INSERT T24.BP I_COMMON
    $INSERT T24.BP I_EQUATE
    $INSERT T24.BP I_F.COMPANY
    $INSERT TAM.BP I_REDO.B.ACCT.PROVINCE.COMMON

    GOSUB INIT
    GOSUB PROCESS.PARA
    RETURN
*-------------------------------------------------------------------------------
PROCESS.PARA:
*------------
    SEL.COMP = "SSELECT ":FN.COMPANY
    CALL EB.READLIST(SEL.COMP,SEL.CLIST,'',REC.CLST,SEL.ERR)

    LOOP
        REMOVE COMP.ID FROM SEL.CLIST SETTING CMP.POSN
    WHILE COMP.ID:CMP.POSN
        YMNEMONIC = ''; ERR.COMP = ''; R.COMPANY1 = ''
        CALL CACHE.READ(FN.COMPANY,COMP.ID,R.COMPANY1,ERR.COMP)
        YMNEMONIC = R.COMPANY1<EB.COM.MNEMONIC>

        FN.RE.CRF.MBGL = 'F':YMNEMONIC:'.RE.CRF.MBGL'
        SEL.LIST = ''; NO.OF.REC = ''; SEL.ERR = ''; SEL.CMD = ''
        SEL.CMD = "SELECT ":FN.RE.CRF.MBGL
        CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.REC,SEL.ERR)
        SEL.FIN.LST<-1> = SEL.LIST
    REPEAT
    CALL BATCH.BUILD.LIST("",SEL.FIN.LST)
    RETURN

INIT:
*****
    SEL.COMP = ''; SEL.CLIST = ''; REC.CLST = ''
    SEL.ERR = ''; SEL.FIN.LST = ''
    RETURN
END
