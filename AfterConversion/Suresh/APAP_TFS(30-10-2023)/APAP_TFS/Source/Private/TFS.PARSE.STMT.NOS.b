* @ValidationCode : MjotMTE5MTU1NTA1NDpDcDEyNTI6MTY5ODMxMjI4MDk4MDphaml0aDotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 26 Oct 2023 14:54:40
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ajith
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
* <Rating>806</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE TFS.PARSE.STMT.NOS(UL.STMT.NOS,RESV.ARG.1,RESV.ARG.2,RESV.ARG.3)
*
* Subroutine to parse the Stmt Nos and return the actual STMT.ENTRY/CATEG.ENTRY
* IDs, prefixed with 'SE-' or 'CE-' as applicable and suffixed with the Company
* where the entry was raised
*------
* Modification History
*
* Mar 17 2008 - Code amended to cater to multibook implementations
*----------------------------------------------------------------------------------
*Modification History:
*DATE                 WHO                    REFERENCE                     DESCRIPTION
*26/10/2023         Ajithkumar             R22 Manual Conversion                USPLATFORM.BP file is Removed
*
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INCLUDE I_T24.FS.COMMON ;*R22 Manual Code Conversion

    $INSERT I_F.COMPANY
    $INSERT I_F.STMT.ENTRY
    $INSERT I_F.CATEG.ENTRY

    GOSUB INIT
    GOSUB PARSE.STMT.FOR.THIS.RECORD

RETURN
*----------------------------------------------------------------------------------
INIT:

    FN.COMP = 'F.COMPANY' ; F.COMP = '' ; CALL OPF(FN.COMP,F.COMP)
    SE.IDS = '' ; CE.IDS = ''

RETURN
*----------------------------------------------------------------------------------
PARSE.STMT.FOR.THIS.RECORD:

    ALL.STMT.NOS = UL.STMT.NOS ; UL.STMT.NOS = ''
    NO.OF.VMS = DCOUNT(ALL.STMT.NOS,@VM)
    ENTRY.COMP = '' ; PREV.ENTRY.COMP = ''
    FOR VM.NO = 1 TO NO.OF.VMS
        POSSIBLE.ENTRY = ALL.STMT.NOS<1,VM.NO>

        IF POSSIBLE.ENTRY MATCHES TFS$COMPANY.LIST THEN
            IF ENTRY.COMP THEN
* Time to build
                CALL F.READV(FN.COMP,ENTRY.COMP,ENTRY.COMP.MNE,EB.COM.MNEMONIC,F.COMP,ERR.COMP)
*-- Mar 17 - 2008 /s
                ENTRY.ID.COMP.MNE = '' ; ENTRY.ID.COMP.MNE = ENTRY.COMP.MNE
                CALL GET.ACCOUNT.COMPANY(ENTRY.ID.COMP.MNE)
*-- Mar 17 - 2008 /e

                IF SE.IDS THEN
                    ENTRY.IDS = SE.IDS ; ENTRY.PREFIX = 'SE'
                    !                    FN.ENTRY.FILE = 'F':ENTRY.COMP.MNE:'.STMT.ENTRY' ; F.ENTRY.FILE = '' ; CALL OPF(FN.ENTRY.FILE,F.ENTRY.FILE)
                    FN.ENTRY.FILE = 'F':ENTRY.ID.COMP.MNE:'.STMT.ENTRY' ; F.ENTRY.FILE = '' ; CALL OPF(FN.ENTRY.FILE,F.ENTRY.FILE)  ;* Mar 17 - 2008 s/e
                    GOSUB BUILD.UL.STMT.NOS
                    SE.IDS = ''
                END
*
                IF CE.IDS THEN
                    ENTRY.IDS = CE.IDS ; ENTRY.PREFIX = 'CE'
                    FN.ENTRY.FILE = 'F':ENTRY.ID.COMP.MNE:'.CATEG.ENTRY' ; F.ENTRY.FILE = '' ; CALL OPF(FN.ENTRY.FILE,F.ENTRY.FILE) ; * Mar 17 - 2008 s/e
                    GOSUB BUILD.UL.STMT.NOS
                    CE.IDS = ''
                END
                ENTRY.COMP = POSSIBLE.ENTRY       ;* Set it to the new Company
            END ELSE
                ENTRY.COMP = POSSIBLE.ENTRY
            END
        END ELSE
            IF NOT(ENTRY.COMP) THEN ENTRY.COMP = ID.COMPANY
            IF INDEX(POSSIBLE.ENTRY,'.',1) THEN
                ENTRY.STEM = POSSIBLE.ENTRY
            END ELSE
                IF INDEX(POSSIBLE.ENTRY,'-',1) OR NUM(POSSIBLE.ENTRY) THEN
                    IF SE.IDS THEN CE.IDS = POSSIBLE.ENTRY ELSE SE.IDS = POSSIBLE.ENTRY
                END
            END
        END

    NEXT VM.NO
* This is for the last loop
    CALL F.READV(FN.COMP,ENTRY.COMP,ENTRY.COMP.MNE,EB.COM.MNEMONIC,F.COMP,ERR.COMP)
*-- Mar 17 - 2008 /s
    ENTRY.ID.COMP.MNE = '' ; ENTRY.ID.COMP.MNE = ENTRY.COMP.MNE
    CALL GET.ACCOUNT.COMPANY(ENTRY.ID.COMP.MNE)
*-- Mar 17 - 2008 /e

    IF SE.IDS THEN
        ENTRY.IDS = SE.IDS ; ENTRY.PREFIX = 'SE'
        FN.ENTRY.FILE = 'F':ENTRY.ID.COMP.MNE:'.STMT.ENTRY' ; F.ENTRY.FILE = '' ; CALL OPF(FN.ENTRY.FILE,F.ENTRY.FILE) ; * Mar 17 - 2008 s/e
        GOSUB BUILD.UL.STMT.NOS
        SE.IDS = ''
    END
*
    IF CE.IDS THEN
        ENTRY.IDS = CE.IDS ; ENTRY.PREFIX = 'CE'
        FN.ENTRY.FILE = 'F':ENTRY.ID.COMP.MNE:'.CATEG.ENTRY' ; F.ENTRY.FILE = '' ; CALL OPF(FN.ENTRY.FILE,F.ENTRY.FILE) ; * Mar 17 - 2008 s/e
        GOSUB BUILD.UL.STMT.NOS
        CE.IDS = ''
    END

    ENTRY.COMP = ''

RETURN
*---------------------------------------------------------------------------
BUILD.UL.STMT.NOS:

    IF NOT(ENTRY.IDS) THEN RETURN

    ENTRY.START = ENTRY.IDS['-',1,1] ; ENTRY.END = ENTRY.IDS['-',2,1]
    IF ENTRY.START GT 0 AND NOT(ENTRY.END) THEN ENTRY.END = ENTRY.START
    FOR ENTRY.NO = ENTRY.START TO ENTRY.END
        ENTRY.ID = ENTRY.STEM : STR(0,4-LEN(ENTRY.NO)) : ENTRY.NO
        CALL F.READ(FN.ENTRY.FILE,ENTRY.ID,R.ENTRY,F.ENTRY.FILE,ERR.ENTRY)
        IF R.ENTRY THEN
            IF UL.STMT.NOS THEN
                UL.STMT.NOS := @VM: ENTRY.PREFIX :'-': ENTRY.ID :'\': ENTRY.COMP
            END ELSE
                UL.STMT.NOS = ENTRY.PREFIX :'-': ENTRY.ID :'\': ENTRY.COMP
            END
        END ELSE
*
* What if there was no Stmt Entry at all but just Categ Entry... it would not
* have been identified in the subroutine above.. So check here
*
            IF ENTRY.PREFIX EQ 'SE' AND NOT(CE.IDS) THEN
                CALL F.READV(FN.COMP,ENTRY.COMP,TEMP.MNE,EB.COM.MNEMONIC,F.COMP,ERR.COMP)
                FN.CATEG.ENTRY = 'F':TEMP.MNE:'.CATEG.ENTRY' ; F.CATEG.ENTRY = '' ; CALL OPF(FN.CATEG.ENTRY,F.CATEG.ENTRY)
                CALL F.READ(FN.CATEG.ENTRY,ENTRY.ID,R.ENTRY,F.CATEG.ENTRY,ERR.CATEG.ENTRY)
                IF R.ENTRY THEN
                    IF UL.STMT.NOS THEN
                        UL.STMT.NOS := @VM: 'CE-' : ENTRY.ID :'\': ENTRY.COMP
                    END ELSE
                        UL.STMT.NOS = 'CE-' : ENTRY.ID :'\': ENTRY.COMP
                    END
                END
            END
        END
    NEXT ENTRY.NO

RETURN
*---------------------------------------------------------------------------
END
