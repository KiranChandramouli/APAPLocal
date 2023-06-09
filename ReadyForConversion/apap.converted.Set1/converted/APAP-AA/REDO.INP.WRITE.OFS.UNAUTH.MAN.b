SUBROUTINE REDO.INP.WRITE.OFS.UNAUTH.MAN
*-----------------------------------------------------------------------------
*DESCRIPTION:
*------------
* This is an input routine which is attached to the version AA.ARRANGEMENT.ACTIVITY,REDO.MAN
* Once after running the OFS.MESSAGE.SERVICE,The unauth record ACTIVITY id is written on
* Flat file AA.ACT.MAN-"today " date is the file name
* FOR online PROCESS
*
* Input/Output:
*--------------
* IN : -NA-
* OUT : -NA-
*---------------
*-----------------------------------------------------------------------------
* Modification History :
*   Date            Who              Reference            Description
* 08-OCT-2010     Kishore.SP      ODR-2009-10-0325      Initial Creation
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_AA.LOCAL.COMMON
    $INSERT I_F.AA.INTEREST
    $INSERT I_GTS.COMMON
    $INSERT I_AA.ACTION.CONTEXT
*-----------------------------------------------------------------------------
*
*The ID of the record is written on the flat file
*
    AA.ACT.ID = ID.NEW
    FILE.NAME = 'TAM.BP'
    RECORD.NAME = "AA.ACT.MAN":"-":TODAY
    F.FILE.PATH = ''
*-----------------------------------------------------------------------------
*
*Open the file before doing the write process
*
    OPENSEQ FILE.NAME,RECORD.NAME TO F.FILE.PATH ELSE
        CREATE F.FILE.PATH THEN
        END
    END
*-----------------------------------------------------------------------------
*
*The ID is assigned to R.FLAT.FILE
*
    R.FLAT.FILE =AA.ACT.ID
*
* The new id is appended with the existing id's
*
    WRITESEQ R.FLAT.FILE APPEND TO F.FILE.PATH THEN
    END
RETURN
*-----------------------------------------------------------------------------
END
